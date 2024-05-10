#!/usr/bin/env sh

ScrDir=`dirname "$(realpath "$0")"`
iDIR="$HOME/.config/waybar/icons"
source $ScrDir/globalcontrol.sh


# define functions

function print_error
{
cat << "EOF"
    ./volumecontrol.sh -[device] <action>
    ...valid device are...
        i -- [i]nput decive
        o -- [o]utput device
    ...valid actions are...
        i -- <i>ncrease volume [+5]
        d -- <d>ecrease volume [-5]
        m -- <m>ute [x]
EOF
}

# Get Volume
get_volume() {
	volume=$(pamixer --get-volume)
	printf "%s\n" "$volume"
}

# Get icons
get_icon() {
	current=$(get_volume)
	if [ "$current" -eq "0" ]; then
		printf "%s\n" "$iDIR/volume-mute.png"
	elif [ "$current" -ge "0" ] && [ "$current" -le "30" ]; then
		printf "%s\n" "$iDIR/volume-low.png"
	elif [ "$current" -ge "30" ] && [ "$current" -le "60" ]; then
		printf "%s\n" "$iDIR/volume-mid.png"
	elif [ "$current" -ge "60" ] && [ "$current" -le "100" ]; then
		printf "%s\n" "$iDIR/volume-high.png"
	fi
}

function notify_vol
{
    vol=`pamixer $srce --get-volume | cat`
    angle="$(( (($vol+2)/5) * 5 ))"
    ico="${icodir}/vol-${angle}.svg"
    bar=$(seq -s "." $(($vol / 15)) | sed 's/[0-9]//g')
    # dunstify "t2" -a "$vol$bar" "$nsink" -i $ico -r 91190 -t 800
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume : $(get_volume) %"
}

function notify_mute
{
    mute=`pamixer $srce --get-mute | cat`
    if [ "$mute" == "true" ] ; then
        dunstify "t2" -a "muted" "$nsink" -i ${icodir}/muted-${dvce}.svg -r 91190 -t 800
    else
        dunstify "t2" -a "unmuted" "$nsink" -i ${icodir}/unmuted-${dvce}.svg -r 91190 -t 800
    fi
}


# set device source

while getopts io SetSrc
do
    case $SetSrc in
    i) nsink=$(pamixer --list-sources | grep "_input." | head -1 | awk -F '" "' '{print $NF}' | sed 's/"//')
        srce="--default-source"
        dvce="mic" ;;
    o) nsink=$(pamixer --get-default-sink | grep "_output." | awk -F '" "' '{print $NF}' | sed 's/"//')
        srce=""
        dvce="speaker" ;;
    esac
done

if [ $OPTIND -eq 1 ] ; then
    print_error
fi


# set device action

shift $((OPTIND -1))
step="${2:-5}"
icodir="~/.config/waybar/icons"

case $1 in
    i) pamixer $srce -i ${step}
        notify_vol ;;
    d) pamixer $srce -d ${step}
        notify_vol ;;
    m) pamixer $srce -t
        notify_mute ;;
    *) print_error ;;
esac

