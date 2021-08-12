#!/bin/zsh

#TARGET=$1

#------------------------------------------------#
echo -e "[+] Start gf sqli v1 [+]"
#------------------------------------------------#
cat parameters.txt | gf sqli | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | anew -q sqliPatterns.txt
#------------------------------------------------#
echo -e "[+] Start sqli v2 [+]"
#------------------------------------------------#
sqlmap -m sqliPatterns.txt --batch --random-agent --level 1 --threads=5
#------------------------------------------------#
