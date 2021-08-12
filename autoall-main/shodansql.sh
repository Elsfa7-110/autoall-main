#!/bin/zsh

#TARGET=$1
#DIR=$2

echo -e "\e[31m
█▀▀ █░░ █▀ █▀▀ ▄▀█ ▀▀█ ▄▄ ▄█ ▄█ █▀█
██▄ █▄▄ ▄█ █▀░ █▀█ ░░█ ░░ ░█ ░█ █▄█
coded by @ELSFA7-110@automotion bughunting@\n\e[0m"

shodan search ssl:"$1"  --fields ip_str,port --separator " " | awk '{print $1":"$2}' | httpx -silent -threads 300 -o wws
python3 dirsearch/dirsearch.py -l wws
echo -e "start sql"
shodan search ssl:"$1"  --fields ip_str,port --separator " " | awk '{print $1":"$2}' | httprobe | httpx -silent -threads 300 -o $1test

sqlmap -m $1test --batch --random-agent --crawl=5 --forms --threads=5
