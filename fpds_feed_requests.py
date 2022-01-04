from typing import Iterator
import pandas as pd
import requests as rq
from concurrent.futures import ThreadPoolExecutor, as_completed
from urllib.parse import quote_plus
# from time import time

class requests:
    MAX_WORKERS = 'max_workers'
    DEFAULT_MAX_WORKERS = 10
    
    def __init__(self, base_url: str, page_size: int=10) -> None:
        self.base_url = base_url
        self.page_size = page_size
    
    def _download_data(self, url: str) -> bytes:
        response = rq.get(url, stream=True)
        if (response.ok == False):
            response.raise_for_status()

        return response.content

    def get(self, param: str, **kwargs) -> Iterator:
        start_index_param = 'start_index'
        start_index = kwargs[start_index_param] if start_index_param in kwargs.keys() else 0
        max_workers = kwargs[requests.MAX_WORKERS] if requests.MAX_WORKERS in kwargs.keys() else requests.DEFAULT_MAX_WORKERS
        max_index = start_index + max_workers * self.page_size
        url_list = [self.base_url + quote_plus(param) + f"&start={start}" for start in range(start_index, max_index, self.page_size)]

        processes = []
        with ThreadPoolExecutor(max_workers) as executor:
            for url in url_list:
                processes.append(executor.submit(self._download_data, url))

        return as_completed(processes)

