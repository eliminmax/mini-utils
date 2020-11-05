#!/bin/bash
echo "This script allows you to use Zenmap's preconfigure profiles in the command line, in case that's more convinient for you.
echo -n "Target: "
read target
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
    "Regular Scan")
      nmap $target ;;
    "Slow comprehensive scan")
      nmap -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script "default or (discovery and safe)" $target ;;
    *) 
      echo "Invalid option $REPLY" ;;
  esac
  break
done
