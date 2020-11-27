function viv {
    local profile=${1:?'expecting a profile'}
    \vivaldi --user-data-dir=$HOME/.config/vivaldi/profiles/${profile} &
}
