pkg_installed()
{
    local PkgIn=$1

    if pacman -Qi "${PkgIn}" &> /dev/null
    then
        #echo "${PkgIn} is already installed..."
        return 0
    else
        #echo "${PkgIn} is not installed..."
        return 1
    fi
}

aur_available()
{
    local PkgIn=$1

    if ${aurhlpr} -Si "${PkgIn}" &> /dev/null
    then
        return 0
    else
        return 1
    fi
}
