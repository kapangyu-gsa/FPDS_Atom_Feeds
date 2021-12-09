import sys, getopt
from fpds_feed_reader import feed_reader

def main(argv):
    search_keyword = ""
    keyword_value = ""
    keyword_value2 = ""
    command_syntax = "fpds_feed.py -s <search_keyword> -v <keyword_value>"
    try:
        opts, args = getopt.getopt(argv,"hs:v:t",["search=","value=","value2"])
    except getopt.GetoptError:
        print(command_syntax)
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print("fpds_feed.py -s <search_keyword> -v <keyword_value> -t <optional_2nd_keyword_value>")
            sys.exit()
        elif opt in ("-s", "--search"):
            search_keyword = arg
        elif opt in ("-v", "--value"):
            keyword_value = arg
        elif opt in ("-t", "--value2"):
            keyword_value2 = arg
    # TODO: need more validations on the arguments        
    if (search_keyword == "") and (keyword_value == ""):
        print(command_syntax)
        sys.exit(2)
              
    param = f'{search_keyword}:"{keyword_value}"' if (keyword_value2 == '') else f'{search_keyword}:[{keyword_value},{keyword_value2}]'
    reader = feed_reader()
    reader.get_data(param)

         
if __name__ == "__main__":
    main(sys.argv[1:])        