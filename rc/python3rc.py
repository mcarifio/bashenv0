# usage: export PYTHONSTARTUP=${BASHENV}/rc/python3rc
# According to the site package, I shouldn't need this.
# http://stackoverflow.com/questions/5837259/installing-pythonstartup-file

try:
    import readline
except ImportError:
    # Silently ignore missing readline module
    pass
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")

