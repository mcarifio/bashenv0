# https://www.reddit.com/r/unixporn/comments/6hctqv/gtk_inspector_for_gnome_shell/

function lg.fn.__template__ {
    local _self=${FUNCNAME[0]}
    u.value $(lg.fn.pathname)
}
# don't export __template__

function lg.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx lg"
}
export -f lg.fn.defines

function lg.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f lg.fn.pathname




function lg {
    gdbus call -e -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval 'const Main = imports.ui.main; if (Main.lookingGlass) { Main.lookingGlass.toggle(); } else { Main.createLookingGlass(); Main.lookingGlass.toggle(); }';
}
export -f lg

