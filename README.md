Mike Carifio <mike@carif.io>

bashenv is local environment for your bash login session and provides an easy way to share scripts across several machines. It's also a bit of a hack.

Install manually:

```bash
git clone git@github.com:mcarifio/bashenv.git ~/.local/share/bashenv
source ~/.local/share/bashenv/install/install.sh # tbs
```

Install scriptily (tbs). Assumes you have `git`, `bash` and `lsb_release` already installed:

```bash
curl -sSH https://raw.githubusercontent.com/mcarifio/bashenv/main/install/$(lsb-release -is)/bin/install.sh | bash
```

By default the script installs in `${HOME}/.local/share/bashenv`. If you'd prefer a different location, use `PREFIX`:

```bash
curl -sSH https://raw.githubusercontent.com/mcarifio/bashenv/main/install/$(lsb-release -is)/bin/install.sh | PREFIX=~/bashenv bash
```


Update (periodically):

```bash
~/.local/share/bashenv/install/$(lsb-release -is)/bin/update.sh
```

Your scripts are, of course, your own and specific to your style and workflow. See [`doc/README.md`](doc/README.md) for more.



