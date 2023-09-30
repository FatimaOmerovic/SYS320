#!/bin/bash

# Script to perform local security checks

function checks() {
	if [[ $2 != $3 ]]
	then

		echo "The $1 is not compliant. Remediation: $4"

	else

		echo "The $1 is compliant. Current Value $3."

	fi
}

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
