import pandas as pd
from lxml import etree
import os, re
import datetime
from fpds_feed_requests import requests
from xml_transform import transform
from multiprocessing import Pool
from util import timer

class feed_reader():
    processing_time_msg = lambda t: f"processing time: {t:.2f} secs"
    
    def __init__(self, 
                 base_url = "https://www.fpds.gov/ezsearch/fpdsportal?s=FPDS.GOV&indexName=awardfull&templateName=1.5.2&rss=1&feed=atom0.3&q=+", 
                 feed_namespace="http://www.w3.org/2005/Atom", 
                 xslt_file: str="fpds_feed.xsl",
                 # the page size is determined by FPDS. Right now it's fixed with 10 records per page 
                 page_size: int=10,
                 # set the limit of rows for each output file. rows = page_size * pages_per_batch
                 pages_per_batch: int=100,
                 # the feed can only return up to 400000 records even though there may be more records that match the search critera 
                 max_rows: int=400000):
        self.feed_namespace = feed_namespace
        self.transfm = transform(xslt_file)
        self.req = requests(base_url, page_size)
        self.page_size = page_size
        self.pages_per_batch = pages_per_batch
        self.max_rows = max_rows      
        self.output_dir = f"{os.getcwd()}/output_files"
    
    def _get_start_index_of_last_page(self, response_content: bytes):
        tree = etree.XML(response_content)
        href = tree.xpath("/f:feed/f:link[@rel = 'last']/@href", namespaces={'f': self.feed_namespace})
        if (len(href) == 0):
            # the link element of last page is not found, return -1
            return -1
        last_page = re.search("start=(\d+)$", href[0])
        return int(last_page.group(1))
    
    def _get_raw_data_from_feed(self, param: str, **kwargs) -> list:
        # send requests in multiple threads to the feed
        tasks_completed = self.req.get(param, **kwargs)
        results = []
        # loop thru the results returned by the threads
        for task in tasks_completed:
            results.append(task.result())
        return results
    
    def _transform_data(self, data: list) -> list:
        # initialize a multiprocessing pool
        with Pool() as pool:
            results = pool.map(self.transfm.to_dataframe, data)
        # some items in the processed results may be None, especially in the last page. So skip those results
        results = [result for result in results if result is not None]
        return results
    
    @timer(processing_time_msg)    
    def _request_data(self, request_num: int, param: str, start_index:int, **kwargs) -> list:
        raw_data = self._get_raw_data_from_feed(param, start_index=start_index, **kwargs)
        results = self._transform_data(raw_data)
        print(f"request #: {request_num}, start index: {start_index}", end=", ")           
        return results
    
    @timer(processing_time_msg)
    def _batch_to_csv(self, batch_results: list, batch_num: int):
        df_batch = pd.concat(batch_results, ignore_index=True)
        # export the current batch result to a .csv file
        output_file = f"{self.output_dir}/batch_{datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S')}.csv"
        try:
            df_batch.to_csv(output_file, encoding = 'utf-8', index=False)
        except FileNotFoundError:
            os.makedirs(self.output_dir)
            df_batch.to_csv(output_file, encoding = 'utf-8', index=False)
        print(f"output batch #: {batch_num}, rows: {len(df_batch)}", end=", ")           
                
    def clear_existing_output_files(self):
        files = os.listdir(self.output_dir)
        for file in files:
            if file.endswith(".csv"):
                os.remove(os.path.join(self.output_dir, file))
        print("Existing output files were successfully removed.")

    def get_data(self, param: str, **kwargs):
        # get the start index of last page from the first returned data
        iter = self.req.get(param, start_index=0, max_workers=1)
        content = next(iter).result()
        last_page_index = self._get_start_index_of_last_page(content)
        if (last_page_index == -1):
            print("No data available for the search criteria.")
            return
        # add page size to the variable so that it will read the last page of data
        last_page_index += self.page_size
        stop_index = last_page_index if (last_page_index < self.max_rows) else self.max_rows
        max_workers = kwargs[requests.MAX_WORKERS] if requests.MAX_WORKERS in kwargs.keys() else requests.DEFAULT_MAX_WORKERS        
        step = max_workers * self.page_size
        request_num = 0
        batch_num = 0
        batch_results = []
        print(f"Requesting data (~{stop_index} rows) from the feed...")
        for start_index in range(0, stop_index, step):
            batch_results += self._request_data(request_num, param, start_index, max_workers=max_workers)
            request_num += 1
            # output the results to a file when the batch is full
            if (len(batch_results) >= self.pages_per_batch):
                self._batch_to_csv(batch_results, batch_num)
                batch_results = []
                batch_num += 1
        if (len(batch_results) > 0):
            # output the last page
            self._batch_to_csv(batch_results, batch_num)
        