# functions to hack/modify bashenv.

# Reload all the functions in "bootstrap" order.
function be.reload {
    verbose=1 u.source $(me.here ../../..)/load.sh
}
export -f be.reload

