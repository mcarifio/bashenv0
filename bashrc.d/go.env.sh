# Mike Carifio <mike@carifio.org>
# Set up GOPATH according to http://golang.org/doc/code.html

export GODEBUG='cgocheck=0'

# Let platform define GOPATH. But if there are multiple locations, get all the bin directories.
gopath=$(go env GOPATH)
export PATH=${gopath//:/\/bin:}/bin:$PATH

# Check that each dir in GOPATH is formulated as a go package.
# In practice, this really means ~/go/**
for g in ${gopath//:/ /} ; do
    for d in src pkg bin ; do
        [[ -d $g/$d ]] || echo "Expecting $g/$d, not found."
    done
done

