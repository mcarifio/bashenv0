# usage: export PYTHONSTARTUP=~/bashenv/rc/python3rc

# http://stackoverflow.com/questions/5837259/installing-pythonstartup-file
try:
    import readline
except ImportError:
    # Silently ignore missing readline module
    pass
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")

