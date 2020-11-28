path_if_exists ~/bin
path_if_exists ~/.local/share/bin
path_if_exists $(realpath -s $(dirname ${BASH_SOURCE})/../bin)
path_if_exists ~/PycharmProjects/dev-tools/bin
path_if_exists ~/.cask/bin 

