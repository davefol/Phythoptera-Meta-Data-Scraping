#!/usr/bin/env python3
import sys
import re

from bs4 import BeautifulSoup

def main():
    soup = BeautifulSoup(sys.stdin.read(), "html.parser")
    substrate_indicator = soup.find("strong", text=re.compile("Substrate"))
    try:
        print(substrate_indicator.next_sibling)
    except AttributeError:
        print("N/A")
        return


if __name__ == "__main__":
    main()
