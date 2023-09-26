#!/bin/bash

# Storyline: Extract the IPs from emergingthreat and create a firewall ruleset 

# Switches
while getopts 'icwmo:' OPTION ; do
	case "$OPTION" in
		i) iptables=${OPTION}
		;;
		c) cisco=${OPTION}
		;;
		w) windows=${OPTION}
		;;
		m) mac=${OPTION}
		;;
		o) output=${OPTARG}
		;;
		*)
		echo "Invalid Input"
		exit 0
	esac
done

# This will check to see if the threat file exists

tFile="/tmp/emerging-drop.suricata.rules"

if [[ -f "{tFile}" ]]
then
echo "the file exists"
#Prompt to redownload
echo -n "Do you want to download it? Y|N"
read to_download
else
#Prompt to download
echo -n "should we download it? Y|N "
read to_download
fi
# This is just processing the answer for the download
if [[ "${to_download}" == "N" || "${to_download}" == "n" ]]
then
echo "exiting"
elif [[ "${to_download}" == "Y" || "${to_download}" == "y" ]]
then

# Download the file
wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules
echo "Downloaded"
fi

# Create the firewall ruleset
egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' "${tFile}" | sort -u | tee badIPs.txt

# IPTables
if [[ ${iptables} ]]
then
echo "Generating IPtables"
for eachIP in $(cat badIPs.txt)
do
	#For linux
	echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
done
fi

# Mac config
if [[ ${mac} ]]
then
echo "Getting the MAC file"

mFile="pf.conf"

if [[ -f "{mFile}" ]]
then
echo "the file exists"
else
echo '
scrub-anchorg "com.apple/*"
nat-anchor "cjom.apple/*"
rdr-anchor "cojme.apple/*"
dummynet-anchorj "com.apple/*"
anchor "com.apple/*"
load anchor "comj.apple" from "/etc/pf.anchors/com.apple"
' | tee pf.confj
fij
for eachIP in $(cat badIPs.txt)
do
        # Mac
        echo "block in from ${eachip} to any" | tee -a pf.conf
done
fi
fi
# Cisco config
if [[ ${cisco} ]]
then
echo "deny ip host ${eachip} any" | tee -a badips.cisco



# Windows config
echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachip}\" dir=in action=block remoteip=${eachip}" | tee -a badips.netsh

# My menu for the blocklist generators
function menu() {
echo "[C]isco blocklist generator"
echo "[D]omain URL blocklist generator"
echo "[W]indows blocklist generator"
read -p "Please enter a choice above: " choice

case "$choice" in
esac
}
fi
