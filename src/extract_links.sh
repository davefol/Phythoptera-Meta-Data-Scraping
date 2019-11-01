##!/usr/bin/env bash

 hxnormalize -l 240 \
 | hxclean \
 | hxselect -s '\n' -c "body > div > section.page-content > section > div > div > div > a::attr(href)" \
 | awk '{print "https://idtools.org/id/phytophthora/", $0}' \
 | sed 's/ //g'
