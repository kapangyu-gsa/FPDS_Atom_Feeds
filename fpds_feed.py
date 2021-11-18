from urllib.parse import quote_plus
from lxml import etree
import pandas as pd
from io import StringIO
import requests

class fpds_feed_reader():
    def __init__(self, base_url = "https://www.fpds.gov/ezsearch/fpdsportal?s=FPDS.GOV&indexName=awardfull&templateName=1.5.2&rss=1&feed=atom0.3&q=+LAST_MOD_DATE", xslt_file: str="fpds_feed.xsl"):
        self.base_url = base_url
        self.xslt_file = xslt_file        
    
    def get_data(self, last_mod_date_start: str="2021/10/01", last_mod_date_end: str="2021/11/01"):
        # TODO: validate the input arguments
        param = f':[{last_mod_date_start},{last_mod_date_end}]'
        url = self.base_url + quote_plus(param)
        response = requests.get(url)
        if (response.ok == False):
            response.raise_for_status()
            
        doc = etree.XML(response.content)
        xslt_tree = etree.parse(self.xslt_file)
        transform = etree.XSLT(xslt_tree)
        result = transform(doc)
        csv_str = str(result)
        df = pd.read_csv(StringIO(csv_str), sep="\t", header=None, index_col=0)
        return df

        