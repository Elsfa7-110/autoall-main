#!/bin/zsh

#TARGET=$1

cat $1 | gauplus --random-agent -retries 20 -t 500 -subs -b png,jpg,gif,svg | anew -q gau_output.txt
#------------------------------------------------#
cat $1 | xargs -P 200 -I % bash -c "echo % | waybackurls" | anew -q way_output.txt
cat $1 | hakrawler -depth 3 -plain >> spider.txt
#------------------------------------------------#
cat gau_output.txt | urldedupe -s | anew -q parameters.txt
cat way_output.txt | urldedupe -s | anew -q parameters.txt
cat spider.txt | urldedupe -s | anew -q parameters.txt
