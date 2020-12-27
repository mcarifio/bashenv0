#!/bin/bash

# select the newest file that satisfies a glob
function newest { 
    stat --printf='%Y\t%n\n' $(find $@)|sort -g -r -k1|head -1|cut -f2
}


old=$(newest $1/*.dsc) ## .dsc of pkg $1
new=$(newest $2/*.dsc) ## .dsc of pkg $2, typically different version of same pkg

# add a suffix to distinquish before and after debdiffs
suffix=${3:-AFTER}
[[ -n "$suffix" ]] && suffix=-${suffix}

# txt file to generate
diff=$PWD/debdiff/$(basename $old)-to-$(basename $new)${suffix}.debdiff.diff


# label and do debdiff
(printf "$diff\n\ndebdiff $old \n\t$new\n\n\nnotes\n\n  - dch -i, pbuild, dh clean, debuild -i -I -sa -S\n\n--------------------------------------------------------------------------------\n\n" ;
debdiff $old $new) > $diff
echo "'$diff'"
ec $diff


