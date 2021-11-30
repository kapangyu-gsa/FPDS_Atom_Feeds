import pandas as pd
from urllib.parse import quote_plus
from lxml import etree
from io import StringIO
# import requests
import re
import time, datetime
from multithreaded_requests import requests as t_requests
from data_transforms import transforms

class fpds_feed_reader():
    def __init__(self, 
                 base_url = "https://www.fpds.gov/ezsearch/fpdsportal?s=FPDS.GOV&indexName=awardfull&templateName=1.5.2&rss=1&feed=atom0.3&q=+", 
                 feed_namespace="http://www.w3.org/2005/Atom", 
                 xslt_file: str="fpds_feed.xsl",
                 page_size: int=100,
                 max_last_page: int=399900):
        self.base_url = base_url
        self.feed_namespace = feed_namespace
        self.xslt_file = xslt_file 
        self.page_size = page_size
        self.max_last_page = max_last_page       
    
    def _get_first_row_num_of_last_page(self, response_content: bytes):
        tree = etree.XML(response_content)
        href = tree.xpath("/f:feed/f:link[@rel = 'last']/@href", namespaces={'f': self.feed_namespace})[0]
        last_page = re.search("start=(\d+)$", href)
        return int(last_page.group(1)) if (last_page is not None) else -1
    
    # def _get_one_page_data(self, param: str, start: int=0):
    #     # encode the parameters
    #     url = self.base_url + quote_plus(param) + f"&start={start}"
    #     response = requests.get(url)
    #     if (response.ok == False):
    #         response.raise_for_status()
        
    #     doc = etree.XML(response.content)
    #     xslt_tree = etree.parse(self.xslt_file)
    #     transform = etree.XSLT(xslt_tree)
    #     result = transform(doc)        
    #     csv_str = str(result)
    #     df = pd.read_csv(StringIO(csv_str), sep="\t", header=None, index_col=0) if (csv_str != "") else None
    #     last_page = -1
    #     if ((start == 0) and (df is not None)):
    #         last_page = self._get_first_row_num_of_last_page(response.content)
    #     return df.T, last_page
              
    # def get_data(self, param: str):
    #     # TODO: validate the input arguments
    #     total_time = 0
        
    #     df_list = []
    #     df, last_page = self._get_one_page_data(param)
    #     if (df is not None):
    #         df_list.append(df)
    #     if (last_page > 0):
    #         stop_page = last_page if (last_page < self.max_last_page) else self.max_last_page
    #         for next in range(self.page_size, stop_page, self.page_size):
    #             start_time = time.time()
    #             df, _ = self._get_one_page_data(param, next)
    #             df_list.append(df)
    #             time_diff = time.time()-start_time
    #             total_time += time_diff
    #             print(f"row {next} of {stop_page}, processing time: {time_diff:.2f} secs")
    #     df_final = pd.concat(df_list)
        
    #     print(f"Total processing time: {str(datetime.timedelta(seconds=total_time))}")

    #     return df_final
        
    def get_data(self, param: str):
        # TODO: add code here
        req = t_requests(self.base_url)
        # get the first 10 rows from the feed
        iter = req.get(param, start_index=0, max_workers=1, page_size=10)
        content = next(iter).result()
        last_page = self._get_first_row_num_of_last_page(content)
        if (last_page > 0):
            stop_page = last_page if (last_page < self.max_last_page) else self.max_last_page
        
        pass
        
            

        
        
        
if __name__ == "__main__":
    reader = fpds_feed_reader()
    df = reader.get_data(f"LAST_MOD_DATE:[2020/04/02, 2020/04/02]")
    # print(f"df shape: {df.shape}")
    # print(df.head())
    # # output dataframe to a .csv file   
    # df.to_csv("fpds_feed_result_code.csv", index=False)
    print(df)
        

        