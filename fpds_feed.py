from fpds_feed_requests import requests
from fpds_feed_reader import feed_reader
from datetime import datetime, timedelta
import time
import argparse


class fpds_feed:
    date_params = ("CREATED_DATE", "LAST_MOD_DATE")

    def __init__(self, clear_output_files: bool=False) -> None:
        self.reader = feed_reader()
        if clear_output_files:
            self.reader.clear_existing_output_files()
    
    def get_data(self, param_name: str, param_value: str, **kwargs):
        param_value_2 = 'param_value_2'
        param = f'{param_name}:[{param_value},{kwargs[param_value_2]}]' if (param_value_2 in kwargs.keys()) else f'{param_name}:"{param_value}"' 
        self.reader.get_data(param, **kwargs)
                  
    def get_by_date_range(self, param_name: str, start_date: str, end_date: str, **kwargs):
        if (param_name not in fpds_feed.date_params):
            print(f"Invalid parameter name: '{param_name}'")
            return
        try:
            s_date = datetime.strptime(start_date, "%Y/%m/%d")
        except ValueError:
            print("start_date must be in the format of 'yyyy/mm/dd'")
            return 
        try:
            e_date = datetime.strptime(end_date, "%Y/%m/%d")
        except ValueError:
            print("end_date must be in the format of 'yyyy/mm/dd'")
            return 
        
        daterange = lambda start, end: [start + timedelta(days=n) for n in range(int((end - start).days))]
        for curr_date in daterange(s_date, e_date):
            date_str = curr_date.strftime("%Y/%m/%d")
            param = f"{param_name}:[{date_str},{date_str}]"
            self.reader.get_data(param, **kwargs)
    
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("s", help="search keyword")
    parser.add_argument("v", help="keyword value or start value")
    parser.add_argument("-o", help="end value")
    parser.add_argument("-w", help="number of worker threads")
    parser.add_argument("-r", help="remove previously generated output files", action="store_true")
    args = parser.parse_args()
    
    feed = fpds_feed(args.r)
    kwargs = {}
    if (args.w is not None):
        if (args.w.isdigit() == False):
            print(f"-w parameter must be an integer.")
            return       
        kwargs[requests.MAX_WORKERS] = int(args.w)
        
    # keep track of the time used for the whole process    
    process_start_time = time.time()

    if (args.s in fpds_feed.date_params):
        feed.get_by_date_range(args.s, args.v, args.o, **kwargs)
    else:
        feed.get_data(args.s, args.v, **kwargs)
        
    process_time = time.time() - process_start_time    
    print(f"Done! total processing time: {str(timedelta(seconds=process_time))}")

if __name__ == "__main__":
    main()        