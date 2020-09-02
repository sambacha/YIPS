#!/bin/bash

cp -rf YIPS/ build/
cd build/YIPS 
ls > yips.txt 
for f in *.md; do cat "$f"; echo "\newline"; done > output.md