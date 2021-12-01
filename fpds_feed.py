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
                 max_rows: int=399990):
        # self.base_url = base_url
        self.feed_namespace = feed_namespace
        self.tf = transform(xslt_file)
        self.req = requests(base_url, page_size)
        self.page_size = page_size
        self.max_rows = max_rows       
    
    def _get_start_index_of_last_page(self, response_content: bytes):
        tree = etree.XML(response_content)
        href = tree.xpath("/f:feed/f:link[@rel = 'last']/@href", namespaces={'f': self.feed_namespace})[0]
        last_page = re.search("start=(\d+)$", href)
        return int(last_page.group(1)) if (last_page is not None) else -1
    
    def _to_csv(self, data: pd.DataFrame, batch_num: int):
        try:
            data.to_csv(f"output_files//batch{batch_num}.csv", encoding = 'utf-8', index=False)
        except FileNotFoundError:
            os.makedirs("output_files")
            data.to_csv(f"output_files//batch{batch_num}.csv", encoding = 'utf-8', index=False)
                
    def get_data(self, param: str, max_workers: int=10):
        total_time = 0
        # get the start index of last page from the first returned data
        iter = self.req.get(param, start_index=0, max_workers=1)
        content = next(iter).result()
        # add page size to the variable so that it will read the last page of data
        last_page_index = self._get_start_index_of_last_page(content) + self.page_size
        if (last_page_index > 0):
            stop_index = last_page_index if (last_page_index < self.max_rows) else self.max_rows
            batch_size = max_workers * self.page_size
            batch_num = 0
            for start_index in range(0, stop_index, batch_size):
                start_time = time.time()
                
                results = []
                tasks_completed = self.req.get(param, start_index, max_workers)
                for task in tasks_completed:
                    df = self.tf.to_dataframe(task.result())
                    if (df is None):
                        continue
                    results.append(df)
                if (len(results) == 0):
                    continue
                df_batch = pd.concat(results)
                # output dataframe to a .csv file
                self._to_csv(df_batch, batch_num)
                                                
                time_diff = time.time()-start_time
                total_time += time_diff
                print(f"batch: {batch_num}, start index: {start_index}, processing time: {time_diff:.2f} secs")
                
                batch_num += 1
        print(f"Total processing time: {str(datetime.timedelta(seconds=total_time))}")


        
if __name__ == "__main__":
    reader = feed_reader()
    reader.get_data(f"LAST_MOD_DATE:[2022/04/02, 2022/04/02]", max_workers=10)
        

        