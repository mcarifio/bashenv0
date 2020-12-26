TODO
====



Make a meta package for quantal with the packages and customizations below.
Assumes ubuntu quantal as the base. These packages were culled from /var/log/apt/history.log

apt-get install -y \
terminator \ # config: ~/.config/terminator
chromium-browser \
ipython3 \
xchat-gnome \ # config: ~/.xchat2
python-sphinx \
emacs24 \ # use emac24 package manager to install more stuff
oracle-java8-installer \ # add-apt-repository -y ppa:webupd8team/java
git \ # config: ~/.gitignore ~/.gitconfig
bzr \ # config: ~/.bazaar
python3-pip \ # pip-3.2 install colorama
meld \ #
yubikey-personalization \ # canonical specific, key configured with
golang{,-mode,-tools} \
euca2ools \
juju{,-jitsu} \ # add-apt-repository -y ppa:juju/pkgs
charm-tools \
charm-helper-sh



