function clip {
    xclip -primary c "${1}" # add more flags like -verbose
}
export -f clip

       
