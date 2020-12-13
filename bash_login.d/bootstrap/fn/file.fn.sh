function file.__template__ {
    local _self=${FUNCNAME[0]}
    echo ${_self} tbs
}
export -f file.__template__



function cd {
    local dir=${1:-${HOME}}
    [[ -d $dir ]] || mkdir -vp $dir
    builtin cd $dir
}
export -f cd

# http://seanbowman.me/blog/fzf-fasd-and-bash-aliases/
function jd {
    local _d=$(find ${1:-*} -path '*/\.*'\
        -prune -o -type d\
        -print 2> /dev/null | fzf +m)
    [ -d "${_d}" ] && pushd "${_d}"
}
export -f jd
complete -d jd


function file.newest { 
    stat --printf='%Y\t%n\n' $(find $*)|sort -g -r -k1|head -1|cut -f2
}
export -f file.newest



function file.is.dir {
    local _self=${FUNCNAME[0]}
    local _d=$(f.must.have "$1" "directory")
    [[ -d ${_d} ]] && printf '%s' ${_d} && true
}
export -f file.is.dir

function file.is.readable {
    local _self=${FUNCNAME[0]}
    local _f=$(f.must.have "$1" "file")
    [[ -r ${_f} ]] && printf '%s' ${_f} && true
}
export -f file.is.readable



function file.mkdir {
    local _self=${FUNCNAME[0]}
    local _d=$(file.must.have "$1" "directory") ; shift
    [[ -d ${_d} ]] || install "$*" --directory ${_d}
}
export -f file.mkdir

function file.mv {
    local _self=${FUNCNAME[0]}
    local _src=$(f.must.have "$1" "directory")
    local _dest=$(f.must.have "$2" "directory")
    mv --backup ${_src} ${_dest} &> /dev/null
}
export -f file.mv

function file.sudo.install { 
    local _self=${FUNCNAME[0]}
    local _src=$(f.must.have "$1" "directory")
    local _dest=$(f.must.have "$2" "directory")
    local _owner=$(f.must.have "${3:-${USER}}" "user")
    local _group=$(f.must.have "${4:-${USER}}" "user")
    sudo install -o ${_owner} -g ${_group} -D ${_src} ${_dest} 
}
export -f file.sudo.install

function file.exec {
    local _self=${FUNCNAME[0]}
    local _cmd=$(u.must.have "$1" "pathname"); shift
    [[ -x {_cmd} ]] && ${_cmd} "${*}"
}
export -f file.exec



function file.path2 {
    local _self=${FUNCNAME[0]}
    local _pathname=$(f.must.have "$1" "pathname")
    file.mkdir $(dirname ${_pathname}) && echo $1
}
export -f file.path2

function file.xz {
    local _self=${FUNCNAME[0]}
    local _from=$(f.must.have "$1" "source file")
    local _to=$(f.must.have "$2" "dest file")
    local _tmp=$(file.path2 /tmp/$USER/${_self}/$$/$(basename ${_to}))
    xz -c $_from ${_tmp} && file.mv ${_tmp} $(file.path2 ${_to})
}
export -f file.xz


