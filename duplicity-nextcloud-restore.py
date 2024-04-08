#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2024 Eli Array Minkoff
#
# SPDX-License-Identifier: GPL-2.0-only

import os
# import sys
import json

from duplicity.backends.webdavbackend import WebDAVBackend
from duplicity.backend import ParsedUrl

# shorter names to keep line length in check
joinpath = os.path.join
getenv = os.environ.get

_home = os.path.expanduser("~")

_config_dir = getenv("XDG_CONFIG_HOME") or joinpath(_home, ".config")
_CFG_FILE = joinpath(_config_dir, "eliminmax-nextcloud-restore", "cfg.json")


def eprint(*args, **kwargs):
    """easy way print to stderr
    If file is specified in kwargs, I'd raise an error, but Python does it
    on its own anyway, so I won't.
    """
    print(*args, **kwargs, file=sys.stderr)


def get_cfg():
    f"""Load config from the config file if it exists, thenprompt the user
    for any missing values.

    Will first try to return the cfg attribute of this function.
    If it's missing, it will load the config, saving it as that attribute.
    This means that if it's called more than once, it only loads the config
    once. This means that the user only has to specify these values once.

    It's a bit of a hacky approach.
    """
    if hasattr(get_cfg, "cfg"):
        return getattr(get_cfg, "cfg")

    if os.path.exists(_CFG_FILE):
        with open(_CFG_FILE, "r") as f:
            cfg = json.load(f)
    else:
        # print a note that these values can be pre-supplied
        eprint(f"NOTE: you can set these values in {_CFG_FILE}.")
        cfg = {}
    
    def get_config_item(item_id, prompt_text):
        if item_id not in cfg:
            cfg[item_id] = input(f"{item_id} ({prompt_text}): ")

    get_config_item("nc_user", "Nextcloud Username")
    get_config_item("nc_host", "Nextcloud domain")
    get_config_item("nc_backup_dir", "Nextcloud backup directory path")
    get_config_item("backup_host", "System that you backed up")
    get_config_item("backup_path", "Path that you backed up")
    setattr(get_cfg, "cfg", cfg)
    return cfg


def get_webdav_interface():
    """Return the duplicity.backends.WebDAVBackend object for

    Will first try to return the interface attribute of this function.
    If it's missing, it will create a new WebDAVBackend instance, and save it
    as that attribute. This ensures that there's only one instance.
    """
    if hasattr(get_webdav_interface, "interface"):
        return getattr(get_webdav_interface, "interface")
    # WebDAVBackend expects a ParsedURL parameter. Generate one using the
    # url_template, populated with values from cfg
    url_template = (
        "webdavs://{nc_user}@{nc_host}/remote/dav/files/{nc_user}/"
        "{nc_backup_dir}/{backup_host}"
    )
    interface = WebDAVBackend(ParsedUrl(url_template.format_map(get_cfg())))

    setattr(get_webdav_interface, "interface", interface)
    return interface
