#!/bin/bash

# Script to perform local security checks

function checks() {
	if [[ $2 != $3 ]]
	then

		echo "The $1 is not compliant. The current policy should be: $2, the current value is: $3. Remediation: $4"

	else

		echo "The $1 is compliant. Current Value $3."

	fi
}

# Check the password max days policy 
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Max Days" "365" "$pmax" "Set PASS_MAX_DAYS to 365 in /etc/login.defs"

# Check for password max
checks "Password Max Days" "365" "${pmax}"

# Check the pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Min Days" "14" "$pmin" "Set PASS_MIN_DAYS to 14 in /etc/login.defs"

# Check the pass warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')
checks "Password Warn Age" "7" "$pwarn" "Set PASS_WARN_AGE to 7 in /etc/login.defs"

# Checks the SSH UsePam configuration
chkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "SSH UsePAM" "yes" "$chkSSHPAM" "Set UsePAM to yes in /etc/ssh/sshd_config"

# Check permission on users home directory
echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk '{print $3}')
do
	chDir=$(ls -ld /home/${eachDir} | awk '{print $1}')
	checks "Home directory ${eachDir}" "drwx------" "$chDir" "Run chmod 700 /home/${eachDir}"
done

# Ensure IP forwarding is disabled
checks "IP Forwarding" "$(sysctl -n net.ipv4.ip_forward)" "0" "Set net.ipv4.ip_forward to 0 in /etc/sysctl.conf"

# Ensure ICMP redirects are not accepted
checks "ICMP Redirects" "$(sysctl -n net.ipv4.conf.all.accept_redirects)" "0" "Set net.ipv4.conf.all.accept_redirects to 0 in /etc/sysctl.conf"

# Ensure permissions on /etc/crontab are configured
checks "Permissions on /etc/crontab" "$(stat -c %a /etc/crontab)" "600" "Run chmod 600 /etc/crontab"

# Ensure permissions on /etc/cron.hourly are configured
checks "Permissions on /etc/cron.hourly" "$(stat -c %a /etc/cron.hourly)" "700" "Run chmod 700 /etc/cron.hourly"

# Ensure permissions on /etc/cron.daily are configured
checks "Permissions on /etc/cron.daily" "$(stat -c %a /etc/cron.daily)" "700" "Run chmod 700 /etc/cron.daily"

# Ensure permissions on /etc/cron.weekly are configured
checks "Permissions on /etc/cron.weekly" "$(stat -c %a /etc/cron.weekly)" "700" "Run chmod 700 /etc/cron.weekly"

# Ensure permissions on /etc/cron.monthly are configured
checks "Permissions on /etc/cron.monthly" "$(stat -c %a /etc/cron.monthly)" "700" "Run chmod 700 /etc/cron.monthly"

# Ensure permissions on /etc/passwd are configured
checks "Permissions on /etc/passwd" "$(stat -c %a /etc/passwd)" "644" "Run chmod 644 /etc/passwd"

# Ensure permissions on /etc/shadow are configured
checks "Permissions on /etc/shadow" "$(stat -c %a /etc/shadow)" "000" "Run chmod 000 /etc/shadow"

# Ensure permissions on /etc/group are configured
checks "Permissions on /etc/group" "$(stat -c %a /etc/group)" "644" "Run chmod 644 /etc/group"

# Ensure permissions on /etc/gshadow are configured
checks "Permissions on /etc/gshadow" "$(stat -c %a /etc/gshadow)" "000" "Run chmod 000 /etc/gshadow"

# Ensure permissions on /etc/passwd- are configured
checks "Permissions on /etc/passwd-" "$(stat -c %a /etc/passwd-)" "644" "Run chmod 644 /etc/passwd-"

# Ensure permissions on /etc/shadow- are configured
checks "Permissions on /etc/shadow-" "$(stat -c %a /etc/shadow-)" "000" "Run chmod 000 /etc/shadow-"

# Ensure permissions on /etc/group- are configured
checks "Permissions on /etc/group-" "$(stat -c %a /etc/group-)" "644" "Run chmod 644 /etc/group-"

# Ensure permissions on /etc/gshadow- are configured
checks "Permissions on /etc/gshadow-" "$(stat -c %a /etc/gshadow-)" "000" "Run chmod 000 /etc/gshadow-"

# Ensure no legacy "+" entries exist in /etc/passwd
checks "Legacy '+' entries in /etc/passwd" "$(grep '^+:' /etc/passwd)" "" "Edit /etc/passwd and remove any lines starting with '+'"

# Ensure no legacy "+" entries exist in /etc/shadow
checks "Legacy '+' entries in /etc/shadow" "$(grep '^+:' /etc/shadow)" "" "Edit /etc/shadow and remove any lines starting with '+'"

# Ensure no legacy "+" entries exist in /etc/group
checks "Legacy '+' entries in /etc/group" "$(grep '^+:' /etc/group)" "" "Edit /etc/group and remove any lines starting with '+'"

# Ensure root is the only UID 0 account
checks "UID 0 accounts" "$(awk -F: '($3 == 0) {print $1}' /etc/passwd)" "root" "Remove any UID 0 accounts except root"
