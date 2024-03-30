#!/bin/bash

source "./scripts/global.sh"
listPkg="./scripts/pkg.lst"
aurhlpr="paru"
use_default="--noconfirm"
packages=()

# Ensure paru is installed
if ! command -v ${aurhlpr} &> /dev/null; then
    echo "Error: ${aurhlpr} is not installed. Please install ${aurhlpr} first."
    exit 1
fi

# Install packages listed in pg.lst
while read -r pkg deps
do
    pkg="${pkg// /}"
    if [ -z "${pkg}" ] ; then
        continue
    fi

    if [ ! -z "${deps}" ] ; then
        deps="${deps%"${deps##*[![:space:]]}"}"
        while read -r cdep
        do
            pass=$(cut -d '#' -f 1 "${listPkg}" | awk -F '|' -v chk="${cdep}" '{if($1 == chk) {print 1;exit}}')
            if [ -z "${pass}" ] ; then
                if pkg_installed "${cdep}" ; then
                    pass=1
                else
                    break
                fi
            fi
        done < <(echo "${deps}" | xargs -n1)

        if [[ ${pass} -ne 1 ]] ; then
            echo -e "\033[0;33m[skip]\033[0m ${pkg} is missing (${deps}) dependency..."
            continue
        fi
    fi

    if pkg_installed "${pkg}" ; then
        echo -e "\033[0;33m[skip]\033[0m ${pkg} is already installed..."
    elif aur_available "${pkg}" ; then
        echo -e "\033[0;34m[aur]\033[0m queueing ${pkg} from arch user repo..."
        packages+=("${pkg}")
    else
        echo "Error: unknown package ${pkg}..."
    fi
done < <( cut -d '#' -f 1 "${listPkg}" )

# ASCII Art
cat <<"EOF"

 _         _       _ _ _
|_|___ ___| |_ ___| | |_|___ ___
| |   |_ -|  _| .'| | | |   | . |
|_|_|_|___|_| |__,|_|_|_|_|_|_  |
                            |___|

EOF
# Install packages using aur
if [[ ${#packages[@]} -gt 0 ]] ; then
    "${aurhlpr}" ${use_default} -S "${packages[@]}"
    # echo "${packages[@]}"
fi

# TODO: Add Checker to check if packages are installed or not.
# TODO: Make log files for installed and failed Installation.

echo "Installation complete."
