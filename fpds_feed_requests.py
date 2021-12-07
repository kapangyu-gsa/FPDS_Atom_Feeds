from typing import Iterator
import pandas as pd
import requests as rq
from concurrent.futures import ThreadPoolExecutor, as_completed
from urllib.parse import quote_plus
# from time import time

class requests:
    
    def __init__(self, base_url: str, page_size: int=10) -> None:
        self.base_url = base_url
        self.page_size = page_size
    
    def _download_data(self, url: str) -> bytes:
        response = rq.get(url, stream=True)
        if (response.ok == False):
            response.raise_for_status()

        return response.content

    def get(self, param: str, start_index: int=0, max_workers: int=10) -> Iterator:
        max_index = start_index + max_workers * self.page_size
        url_list = [self.base_url + quote_plus(param) + f"&start={start}" for start in range(start_index, max_index, self.page_size)]

        processes = []
        with ThreadPoolExecutor(max_workers) as executor:
            for url in url_list:
                processes.append(executor.submit(self._download_data, url))

        return as_completed(processes)

