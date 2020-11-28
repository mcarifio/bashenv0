Mike Carifio <mike@carif.io>

bashenv is local environment for your bash login session and provides an easy way to share scripts across several machines.

Install

```bash
git clone git@github.com:mcarifio/bashenv.git ~/.local/share/bashenv
source ~/.local/share/bashenv/install/install.sh # tbs
```

Update (periodically):

```bash
~/.local/share/bashenv/install/update.sh
```

Note that if you change or add a script, you should push it here and then `update.sh` on other machines.


