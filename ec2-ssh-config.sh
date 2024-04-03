#!/bin/bash

# SPDX-FileCopyrightText: 2021-2022 Eli Array Minkoff
#
# SPDX-License-Identifier: 0BSD

read -r -p "Path to Identity file: " identityfile
mkdir -p ~/.ssh/aws

wget -O /tmp/aws-ip-ranges.json https://ip-ranges.amazonaws.com/ip-ranges.json
jq -r '.prefixes[] | select(.service=="EC2") | .ip_prefix' </tmp/aws-ip-ranges.json > ~/.ssh/aws/ec2-cidr.json
rm /tmp/aws-ip-ranges.json
printf "Appending the following to ~/.ssh/config:\n"
printf "Match exec \"grepcidr -f ~/.ssh/aws/ec2-cidr.json <(echo %%h) &>/dev/null\"\n\tIdentityFile %s\n" \
	"$identityfile" | \
	tee -a ~/.ssh/config
