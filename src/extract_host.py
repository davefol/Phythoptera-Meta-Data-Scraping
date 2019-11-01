#!/usr/bin/env python3
import sys
import re

from bs4 import BeautifulSoup

def main():
    soup = BeautifulSoup(sys.stdin.read(), "html.parser")
    host_indicator = soup.find("strong", text=re.compile("Host"))
    try:
        current_text = host_indicator.next_sibling
    except AttributeError:
        print ("N/A")
        return
    if current_text:
        try:
            print(current_text.text, end="")
        except AttributeError:
            print(current_text, end="")
    else:
        print("N/A")
        return 

    while current_text:
        try:
            current_text = current_text.next_sibling
        except AttributeError:
            print ("N/A")
            return
        if current_text:
            try:
                print(current_text.text, end="")
            except AttributeError:
                print(current_text, end="")
    print("\n", end="")

if __name__ == "__main__":
    main()
