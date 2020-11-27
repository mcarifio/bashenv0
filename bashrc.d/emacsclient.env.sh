# for use by emacsd

# Q: execute once, e.g. .profile.d?
systemctl --user import-environment PATH

export ALTERNATE_EDITOR=''

# Prefer emacsclient when possible
EMACS=emacsclient
export EDITOR=$EMACS VISUAL=$EMACS

