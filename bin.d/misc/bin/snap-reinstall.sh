#!/usr/bin/env bash


function snap_installed {
    snap list $1 > /dev/null
}

function si {
    name=${1:?'no name'}
    track=${4:-stable}
    note=${6}
    snap_installed ${name} && { echo "${name} already installed, skipping..."; return; }
    
    flag=''
    if [[ ${node} -eq 'classic' ]] ; then
        flag='--classic'
    elif [[ ${node} -eq 'devmode' ]] ; then
        flag='--devmode --beta'
    fi
    echo "sudo snap install ${name} ${flag}"
}


# si anbox                   4-558d646                   92    beta         morphis                devmode
si chromium                78.0.3904.70                909   stable       canonical*             -
si chromium-ffmpeg         0.1                         15    stable       canonical*             -
si clion                   2019.2.4                    88    stable       jetbrains*             classic
si code                    6ab59852                    18    stable       vscode*                classic

# juju
si conjure-up              2.6.8-20190930.1409         1056  edge         canonical*             classic
# si core                    16-2.42                     7917  stable       canonical*             core
# si core18                  20191010                    1223  stable       canonical*             base
si datagrip                2019.2.5                    61    stable       jetbrains*             classic
si discord                 0.0.9                       93    stable       snapcrafters           -
si docker                  18.06.1-ce                  384   stable       canonical*             -
si dotnet-sdk              3.0.100                     49    stable       dotnetcore*            classic
si etcd                    3.2.10                      202   stable       canonical*             -
si freecad                 0.18                        8     stable       vejmarie               -
si gitea                   v1.9.0-dev+git29.d578b71    4728  edge         gitea                  -
# si gitkraken               6.3.0                       145   stable       gitkraken*             -
# si gnome-3-28-1804         3.28.0-14-g9303a49.9303a49  91    stable       canonical*             -
# si gnome-calculator        3.34.1+git1.d34dc842        544   stable/…     canonical*             -
# si gnome-characters        v3.32.1+git2.3367201        359   stable/…     canonical*             -
# si gnome-logs              3.34.0                      81    stable/…     canonical*             -
si go                      1.12.12                     4678  1.12         mwhudson               classic
si goland                  2019.2.3                    69    stable       jetbrains*             classic
si gtk-common-themes       0.1-25-gcc83164             1353  stable       canonical*             -
# si guvcview                2.0.6+pkg-f796              81    stable       brlin                  -
si hello                   2.10                        38    stable       canonical*             -
si hello-world-electron    0.1.0                       1     stable       jhudielb               -
si hub                     v2.12.8                     25    stable       felicianotech          classic
si insomnia                7.0.3                       37    stable       gschier1990            -
si intellij-idea-ultimate  2019.3-EAP                  180   edge         jetbrains*             classic
si ipfs                    v0.4.21                     1170  stable       elopio                 -
si j2                      0.3.1-0                     1     stable       cmars                  -
# si julia                   1.0.4                       13    stable       julialang*             classic
si julia-stable            1.0.0                       1     stable       fmind                  -
si kotlin                  1.3.50                      38    stable       jetbrains*             classic
si kotlin-native           0.9.3                       13    stable       jetbrains*             classic
si links                   2.18                        33    stable       snapcrafters           -
# si mailspring              1.7.2                       407   stable       foundry376*            -

# simulate cloud spinup
si multipass               0.8.1                       1230  latest/beta  canonical*             classic
si notepad-plus-plus       7.8                         216   stable       mmtrt                  -
si opera                   64.0.3417.73                57    stable       opera-software*        -
# si pdftk                   2.02-4                      9     stable       smoser                 -
si postman                 7.10.0                      96    stable       postman-inc*           -
si powershell              6.2.3                       39    stable       microsoft-powershell*  classic
si powershell-preview      7.0.0-preview.4             32    stable       microsoft-powershell*  classic
si protobuf                3.9.0                       24    stable       stub                   classic
si pycharm-professional    2019.2.3                    159   stable       jetbrains*             classic
si pypy3                   7.2.0                       37    stable       pypyproject            classic
si rider                   2019.2.3                    29    stable       jetbrains*             classic
si robo3t-snap             v1.3.1                      4     stable       shalev67               -
si rubymine                2019.2.3                    115   stable       jetbrains*             classic
si slack                   4.1.1                       18    stable       slack*                 classic
si snapcraft               3.8                         3440  stable       canonical*             classic
si vysor                   2.1.7                       x1    -            -                      -
si webstorm                2019.2.3                    112   stable       jetbrains*             classic
si wine-platform-4-stable  3.0.4                       6     stable       mmtrt                  -
si wine-platform-runtime   v1.0                        51    stable       mmtrt                  -
# si yakyak                  1.5.3                       45    stable       snapcrafters           -
si zola                    0.5.0+git                   51    edge         keats                  -


# k8s
si microk8s                v1.16.2                     993   stable       canonical*             classic
