import pandas as pd
from lxml import etree
from io import StringIO

class transforms:
    def __init__(self, xslt_file: str) -> None:
        self.xslt_file = xslt_file
    
    def to_csv(self, data: bytes):
        doc = etree.XML(data)
        xslt_tree = etree.parse(self.xslt_file)
        transform = etree.XSLT(xslt_tree)
        result = transform(doc)        
        csv_str = str(result)
        if (csv_str == ""):
            return None
        
        df = pd.read_csv(StringIO(csv_str), sep="\t", header=None, index_col=0)
        # need to transpose the data to get the right format
        return df.T
