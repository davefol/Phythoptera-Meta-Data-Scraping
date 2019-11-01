#!/usr/bin/env bash

hxclean \
| hxselect -s '\n' "h6, h6 + p" \
| hxunent
