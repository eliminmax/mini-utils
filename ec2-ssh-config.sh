#!/bin/bash
# Copyright © 2021 Eli Array Minkoff
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.

#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

read -p "Path to Identity file: " identityfile
mkdir -p ~/.ssh/aws

wget -O /tmp/aws-ip-ranges.json https://ip-ranges.amazonaws.com/ip-ranges.json
jq -r '.prefixes[] | select(.service=="EC2") | .ip_prefix' </tmp/aws-ip-ranges.json > ~/.ssh/aws/ec2-cidr.json
rm /tmp/aws-ip-ranges.json
printf "Appending the following to ~/.ssh/config:\n"
printf "Match exec \"grepcidr -f ~/.ssh/aws/ec2-cidr.json <(echo %%h) &>/dev/null\"\n\tIdentityFile %s\n" \
	$identityfile | \
	tee -a ~/.ssh/config
