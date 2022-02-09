import functools
import time

def timer(processing_time_msg):
    def decorator(func):
        """Print the runtime of the decorated function"""
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            start_time = time.perf_counter()    # 1
            value = func(*args, **kwargs)
            end_time = time.perf_counter()      # 2
            run_time = end_time - start_time    # 3
            if (processing_time_msg is not None):
                print(processing_time_msg(run_time))
            return value
        return wrapper
    return decorator
