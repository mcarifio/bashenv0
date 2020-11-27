_main() {
    local l=1
    _child
}

_child() {
    echo $l
}

