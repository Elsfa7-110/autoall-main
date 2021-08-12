#! /bin/bash

set -e

cyan="\e[0;36m"
end="\e[0m"

echo -e "$cyan
 _____              __           _____   
| ____| | |  ___   / _|   __ _  |___  |   / / |/ _ \  
|  _|   | | / __| | |_   / _` |    / /____| | | | | | 
| |___  | | \__ \ |  _| | (_| |   / /_____| | | |_| | 
|_____| |_| |___/ |_|    \__,_|  /_/      |_|_|\___/  

$end\n"

printf "Installing GF..\n"
go get -u github.com/tomnomnom/gf
printf "Installing waybackurls ..\n"
go get github.com/tomnomnom/waybackurls
printf "Installing Dalfox..\n"
GO111MODULE=on go get -v github.com/hahwul/dalfox/v2
printf "Installing gau..\n"
GO111MODULE=on go get -u -v github.com/lc/gau
printf "Setting up GF Patterns\n"
mkdir ~/.gf
cp -r $GOPATH/src/github.com/tomnomnom/gf/examples ~/.gf
cd ~
git clone https://github.com/1ndianl33t/Gf-Patterns
mv ~/Gf-Patterns/*.json ~/.gf
printf "Installing kxss..\n"
go get -u github.com/tomnomnom/hacks/kxss
printf "Installing qsreplace..\n"
go get -u github.com/tomnomnom/qsreplace
printf "Installing assetfinder..\n"
go get -u github.com/tomnomnom/assetfinder
printf "Installing subfinder..\n"
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
printf "Installing amass..\n"
sudo snap install amass
printf "Installing httprobe..\n"
go get -u github.com/tomnomnom/httprobe
printf "Installing subzy..\n"
go get -u -v github.com/lukasikic/subzy
go install -v github.com/lukasikic/subzy
printf "Installing nuclei..\n"
GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei
printf "Installing titlextractor..\n"
go get -u golang.org/x/net/html
go get -u github.com/dellalibera/titlextractor/
printf "Installing notify..\n"
GO111MODULE=on go get -v github.com/projectdiscovery/notify/cmd/notify
printf "Installing crlfuzz..\n"
GO111MODULE=on go get -v github.com/dwisiswant0/crlfuzz/cmd/crlfuzz
printf "Installing findomain..\n"
git clone https://github.com/Edu4rdSHL/findomain.git
cd findomain
cargo build --release
sudo cp target/release/findomain /usr/bin/
findomain
printf "Installing anew..\n"
go get -u github.com/tomnomnom/anew
printf "Installing anew..\n"
printf "${bgreen} Finished!${reset}\n\n"
