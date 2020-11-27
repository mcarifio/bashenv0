# Add "local" and optional scripts to PATH.
# Conventions:
# * personal scripts in ~/.local/share/bin, ~/.local/share/*/bin, e.g. ~/.local/share/git/bin
# * custom installs shared across all machine users: /opt/${tool}/${version}/bin

export PATH=$(shopt -s nullglob globstar; printf "%s:" ${HOME}/.local/share/*/bin/ /opt/**/current/bin/):$PATH
