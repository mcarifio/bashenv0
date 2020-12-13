# https://www.reddit.com/r/unixporn/comments/6hctqv/gtk_inspector_for_gnome_shell/

function lg {
    gdbus call -e -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval 'const Main = imports.ui.main; if (Main.lookingGlass) { Main.lookingGlass.toggle(); } else { Main.createLookingGlass(); Main.lookingGlass.toggle(); }';
}
export -f lg

