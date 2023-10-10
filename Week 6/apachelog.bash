#!/bin/bash

# This line reads the Apache log file :)
read -p "Please enter the path to the Apache log file: " tFile

# Checks if the file inputted from user exists :)
if [[ ! -f ${tFile} ]]; then
  echo "The file inputted doesn't exist."
  exit 1
fi

# Parse the Apache log file to extract unique IP addresses
ip_addresses=$(awk '{print $1}' ${tFile} | sort -u)

# Checks if there are IP addresses to create rules for :)
if [[ -z ${ip_addresses} ]]; then
  echo "No IP addresses found in the log file."
  exit 1
fi

# Prints the unique IP addresses :)
echo "Unique IP addresses in the log file:"
echo "${ip_addresses}"

# Creates IPTables ruleset :)
echo "Creating IPTables ruleset..."
for ip in ${ip_addresses}; do
  
  # Adds each IP address to the IPTables ruleset :)
  iptables -A INPUT -s ${ip} -j ACCEPT
  echo "Added rule to allow traffic from IP: ${ip}"
done

echo "IPTables ruleset created successfully."
