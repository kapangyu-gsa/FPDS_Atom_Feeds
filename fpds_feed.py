import sys, argparse
from fpds_feed_reader import feed_reader

def main(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument("s", help="search keyword")
    parser.add_argument("v", help="keyword value or start value")
    parser.add_argument("-u", help="end value")
    args = parser.parse_args()
              
    param = f'{args.s}:"{args.v}"' if (args.u is None) else f'{args.s}:[{args.v},{args.u}]'
    reader = feed_reader()
    reader.get_data(param)
    
         
if __name__ == "__main__":
    main(sys.argv[1:])        