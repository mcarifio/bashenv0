#!/usr/bin/env bash

user_data_dir=${1:-${HOME}/.config/chromium/Default}
(set -x; chromium-browser --disable-web-security -–allow-file-access-from-files --user-data-dir=${user_data_dir})
