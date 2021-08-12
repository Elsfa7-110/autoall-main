#!/bin/zsh

#TARGET=$1

#------------------------------------------------#
bash fullxss.sh $1
#------------------------------------------------#
bash fullopen.sh $1
#------------------------------------------------#
bash lfi.sh $1
#------------------------------------------------#
bash ssti.sh $1
#------------------------------------------------#
bash sensitive.sh $1
#------------------------------------------------#
bash sqli.sh $1
#------------------------------------------------#
rm parameters.txt xssPatterns.txt way_output.txt gau_output.txt spider.txt redirectPatterns.txt lfiPatterns.txt subfinder.txt findomain.txt crobat.txt Final-subs.txt crlfuzz.txt sqliPatterns.txt
