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


echo "zencli Copyright © 2021 Eli Array Minkoff."
echo "This program comes with ABSOLUTELY NO WARRANTY; for details, see the LICENCE file."
echo "This is free software, and you are welcome to redistribute it under certain conditions; for details, see the LICENCE file."


echo "This script allows you to use Zenmap's preconfigured profiles in the command line, in case that's more convinient for you."
read -p "Target: " target
select opt in "Intense scan" "Intense scan plus UDP" "Intense scan, all TCP ports" "Intense scan, no ping" "Ping scan" "Quick scan" "Quick scan plus" "Quick traceroute" "Regular scan" "Slow comprehensive scan" ; do
  case $opt in
    "Intense scan")
      nmap -T4 -A -v $target ;;
    "Intense scan plus UDP")
      nmap -sS -sU -T4 -A -v $target ;;
    "Intense scan, all TCP ports")
      nmap -p 1-65535 -T4 -A -v $target ;;
    "Intense scan, no ping")
      nmap -T4 -A -v -Pn $target ;;
    "Ping scan")
      nmap -sn $target ;;
    "Quick scan")
      nmap -T4 -F $target ;;
    "Quick scan plus")
      nmap -sV -T4 -O -F --version-light $target ;;
    "Quick traceroute")
      nmap -sn --traceroute $target ;;
    "Regular scan")
      nmap $target ;;
    "Slow comprehensive scan")
      nmap -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script default or discovery and safe $target ;;
    *) 
      echo "Invalid option $REPLY" ;;
  esac
  break
done
