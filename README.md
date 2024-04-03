<!--
SPDX-FileCopyrightText: 2020-2024 Eli Array Minkoff

SPDX-License-Identifier: 0BSD
-->

# mini-utils
A repository for simple command-line utilites that I've made for myself, but am happy to share with the world.

The quality of the scripts and documentation varies. If you don't find something useful, don't use it.

This is what each utility in the repository does:

* `ec2-ssh-config.sh`: a tool to add a setting to the ssh config file for Amazon's EC2 IP addresses, so that it will automatically use an ec2-specific identity file for any of them. Uses **wget** to download a json file from Amazon with a list of their ip subranges, **jq** to parse out the subnets used for ect, and creates an entry in ~/.ssh/config
  * depends: **grepcidr**, **jq**, **wget**

* `usb_boot`: a simple python wrapper to let you use **QEMU** to test a bootable USB drive using the technique documented in [this article on coderwall.com](https://coderwall.com/p/1usy5a/test-your-bootable-usb-drive-with-qemu), and calling the commands with the [python `subprocess` module](https://docs.python.org/3/library/subprocess.html).
  * depends: **python** *(>=3.5)*, **qemu-system-x86_64**, **qemu-kvm** *optional, can use without kvm with lowered performance*, **sudo**
  * note: QEMU requires root permissions to have write access to the usb drive, and will not boot it without that. I would encourage anyone who wants to use this script to read it over before running it, given that it creates a subprocess with root-level permissions using sudo.

* `remove-color-escapes`, `show-color-escapes`: pure python tools to remove or show color/text formatting ANSI escape seqences (specifically those that match the regular expression `'\x1b\\[[0-9;]*m'`).

* `setup-sandbox.sh`: creates a simple sandboxed X11 environment to run a command in.
  * usage: `setup-sandbox.sh /path/to/sandbox/homedir command-to-run command-args*`
  * depends: **Xephyr** *(an optional part of Xorg)*, **Bubblewrap** *(a sandboxing tool)*, and **awesome** *(a lightweight window manager)*

* `spipx` is a wrapper around the `pipx` utility that, when run as root, creates the venvs and other such data in /opt/pipx, and installs the binaries to /opt/pipx/bin
  * depends: **pipx**

* `cmark-gfm-heading-generator` is an AWK script that adds headings to the output of [cmark-gfm](https://github.com/github/cmark-gfm). It specifically  requires support for the `\uHH` escape sequence, which is non-standard, so it requires at least the onetrueawk 2ndEdition release or GAWK 5.3.0, both of which are too new to be included in Debian Bookworm - I compiled them from source. It breaks if `LC_ALL` is set to certain values — on my system, which has the `C`, `C.utf8`, `en_US.utf8`, and `POSIX` locales, it only worked if the `LC_ALL` environment variable was either unset or set to `C.utf8` or `en_US.utf8`. The shebang depends on specific GNU `env` functionality too, but you can invoke it directly or edit the shebang to get around that.
  * usage: `cmark-gfm some-markdown-file.md | cmark-gfm-heading-generator > index.html`
  * depends: **gawk** >= 5.3.0 or **onetrueawk** >= 2ndEdition, utf8 locale
