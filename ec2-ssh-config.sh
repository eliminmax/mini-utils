#!/bin/bash
# Copyright © 2021 Eli Array Minkoff

# Permission to use, copy, modify, and/or distribute this software for
# any purpose with or without fee is hereby granted.

# THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
# FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY
# DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
# AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
# OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

read -r -p "Path to Identity file: " identityfile
mkdir -p ~/.ssh/aws

wget -O /tmp/aws-ip-ranges.json https://ip-ranges.amazonaws.com/ip-ranges.json
jq -r '.prefixes[] | select(.service=="EC2") | .ip_prefix' </tmp/aws-ip-ranges.json > ~/.ssh/aws/ec2-cidr.json
rm /tmp/aws-ip-ranges.json
printf "Appending the following to ~/.ssh/config:\n"
printf "Match exec \"grepcidr -f ~/.ssh/aws/ec2-cidr.json <(echo %%h) &>/dev/null\"\n\tIdentityFile %s\n" \
	"$identityfile" | \
	tee -a ~/.ssh/config
