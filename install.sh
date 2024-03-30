./scripts/pkg_installer.sh
./scripts/enable_Services.sh

### Copy Config Files ###
read -n1 -rep 'Would you like to copy config files? (y,n)' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "Copying config files...\n"
    cp -R .config/* ~/.config/
    # Set some files as exacutable
    chmod +x ~/.config/hypr/scripts/*
    chmod +x ~/.config/waybar/scripts/*
    fc-cache -fv
  else
    exit
fi
