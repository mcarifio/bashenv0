# source
# assumes go-t install and in PATH

function twt.status {
    go-t status update -y -f -
}
export -f twt.status
