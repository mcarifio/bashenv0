# https://docs.volta.sh/advanced/installers
# reinstall in ~/.local/share/volta: curl https://get.volta.sh | VOLTA_HOME=~/.local/share/volta bash -s -- --skip-setup

u.have.command volta && export VOLTA_HOME=$(realpath $(dirname $(type -p volta))/..)

