#!/usr/bin/env bash
function pip {
    python3 -m pip install --upgrade $*
}

pip pip


# git-sclone
# https://google.github.io/python-fire/guide/
pip git+https://github.com/google/python-fire@v0.3.1#egg=fire
pip git-url-parse gitpython dotmap
