function viv.run {
    local profile=${1:?'expecting a profile'}
    command vivaldi --user-data-dir=$HOME/.config/vivaldi/profiles/${profile} &
}
export -f viv.run

