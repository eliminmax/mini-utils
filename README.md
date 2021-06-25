# cl-net-utils
A repository for simple command-line sysadmin and networking tools that I've made for myself, but am happy to share with the world.

This is what each file in the repository does:

* `zencli.sh`: a menu to quickly run nmap commands based on Zenmap's preconfigured profiles
  * depends: **nmap**
* `ec2-ssh-config.sh`: a tool to add a setting to the ssh config file for Amazon's EC2 IP addresses, so that it will automatically use an ec2-specific identity file for any of them. Uses **wget** to download a json file from Amazon with a list of their ip subranges, **jq** to parse out the subnets used for ect, and creates an entry in ~/.ssh/config
  * depends: **grepcidr**, **jq**, **wget**
* `usb_boot`: a simple python wrapper to let you use **QEMU** to test a bootable USB drive using the technique documented in [this article on coderwall.com](https://coderwall.com/p/1usy5a/test-your-bootable-usb-drive-with-qemu), and calling the commands with the [python `subprocess` module](https://docs.python.org/3/library/subprocess.html).
  * depends: **python** *(>=3.5)*, **qemu-system-x86_64**, **sudo**
> Note: QEMU requires root permissions to have write access to the usb drive, and will not boot it without that. I would encourage anyone who wanys to use this script to read it over before running it, given that it creates a subprocess with root-level permissions using sudo.
