#!/usr/bin/env python
import re
import os

PLUGIN_HOME = os.path.dirname(os.path.abspath(__file__))
FILE_LIST = PLUGIN_HOME.replace("plugin", "data") + "/tmpFL"

def parse_paragraphs_from_text(text):
   
    pat = re.compile(r'^ *\n', re.MULTILINE)
    paragraphs = [x for x in re.split(pat, text) if x != '']

    return paragraphs

def output_collect_browser_text(fileList, withTags = "@i"):

    # names of tags sep by space that you want to collect
    withTags = withTags.split()

    with open(fileList, 'r') as f:
        fNs = [x.strip() for x in f.readlines()]        

    paragraphs = []
    for fN in fNs:
        with open(fN, 'r') as f:
            paragraphs = parse_paragraphs_from_text(f.read())

    def text_has_tags(text, tags):
        for tag in tags:
            if tag in text:
                return True
        return False

    paragraphs = [para for para in paragraphs if text_has_tags(para, withTags)]

    for p in paragraphs:
        print p

if __name__ == "__main__":
    import sys
    output_collect_browser_text(FILE_LIST, sys.argv[1])
