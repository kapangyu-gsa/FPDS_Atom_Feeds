import sys, argparse
from fpds_feed_reader import feed_reader

def main(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument("s", help="search keyword")
    parser.add_argument("v", help="keyword value or start value")
    parser.add_argument("-o", help="end value")
    parser.add_argument("-w", help="number of threads")
    args = parser.parse_args()
              
    param = f'{args.s}:"{args.v}"' if (args.o is None) else f'{args.s}:[{args.v},{args.o}]'
    reader = feed_reader()
    if (args.w is None):
        reader.get_data(param)    
    else:
        reader.get_data(param, int(args.w))
    

if __name__ == "__main__":
    main(sys.argv[1:])        