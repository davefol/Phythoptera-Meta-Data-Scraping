#!/usr/bin/env bash
hxclean \
| hxselect "section.note:first-child > div.text > p:nth-of-type(2)" \
| hxunent \
| sed -e 's/<[^>]*>//g'
