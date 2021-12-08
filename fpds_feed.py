import pandas as pd
from urllib.parse import quote_plus
from lxml import etree
import os
import re
import time, datetime
from fpds_feed_requests import requests
from xml_transform import transform

class feed_reader():
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
        self.tf = transform(xslt_file)
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
    
    def _request_data(self, request_num: int, param: str, start_index:int, max_workers:int) -> list:
        start_time = time.time()
        # send requests in multiple threads to the feed
        tasks_completed = self.req.get(param, start_index, max_workers)
        results = []
        # loop thru the results returned by the threads
        for task in tasks_completed:
            df = self.tf.to_dataframe(task.result())
            # some worker threads may not have data to process in the last page. So skip those results
            if (df is None):
                continue
            results.append(df)
        time_diff = time.time()-start_time
        print(f"request #: {request_num}, start index: {start_index}, processing time: {time_diff:.2f} secs")           
        return results
        
    def _batch_to_csv(self, batch_results: list, batch_num: int):
        start_time = time.time()
        df_batch = pd.concat(batch_results, ignore_index=True)
        # export the current batch result to a .csv file
        output_file = f"{self.output_dir}/batch{batch_num}.csv"
        try:
            df_batch.to_csv(output_file, encoding = 'utf-8', index=False)
        except FileNotFoundError:
            os.makedirs(self.output_dir)
            df_batch.to_csv(output_file, encoding = 'utf-8', index=False)
        time_diff = time.time()-start_time
        print(f"output batch #: {batch_num}, rows: {len(df_batch)}, processing time: {time_diff:.2f} secs")           
                
    def _remove_csvs(self):
        files = os.listdir(self.output_dir)
        for file in files:
            if file.endswith(".csv"):
                os.remove(os.path.join(self.output_dir, file))

    def get_data(self, param: str, max_workers: int=10):
        # keep track of the time used for the whole process    
        start_time = time.time()
        # remove the old csv files
        self._remove_csvs()
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
        step = max_workers * self.page_size
        request_num = 0
        batch_num = 0
        batch_results = []
        print(f"Requesting data (~{stop_index} rows) from the feed...")
        for start_index in range(0, stop_index, step):
            batch_results += self._request_data(request_num, param, start_index, max_workers)
            request_num += 1
            # output the results to a file when the batch is full
            if (len(batch_results) >= self.pages_per_batch):
                self._batch_to_csv(batch_results, batch_num)
                batch_results = []
                batch_num += 1
        if (len(batch_results) > 0):
            # output the last page
            self._batch_to_csv(batch_results, batch_num)
        
        process_time = time.time()-start_time    
        print(f"Done! total processing time: {str(datetime.timedelta(seconds=process_time))}")


        
if __name__ == "__main__":
    reader = feed_reader()
    reader.get_data(f"LAST_MOD_DATE:[2021/11/28, 2021/11/28]", max_workers=10)
        