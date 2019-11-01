#!/usr/bin/env python3
import sys
import re

from bs4 import BeautifulSoup

def main():
    soup = BeautifulSoup(sys.stdin.read(), "html.parser")
    sexual_header = soup.find("h6", text=re.compile("Sex"))
    try:
        print(sexual_header.findNext('p').text)
    except AttributeError:
        print ("N/A")
    

if __name__ == "__main__":
    main()
