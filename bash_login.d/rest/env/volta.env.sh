# https://docs.volta.sh/advanced/installers
# curl https://get.volta.sh | bash -s -- --skip-setup
u.have.command volta && export VOLTA_HOME=$(realpath -s $(dirname $(type -p volta))/..)

# Hack
[[ "$1" = "--upgrade" && -n "${VOLTA_HOME}" ]] && curl https://get.volta.sh | bash -s -- --skip-setup
