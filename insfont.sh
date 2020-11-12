#!/bin/bash
# make by homepai26 - pai

FONTDIR=/usr/share/fonts
upfontlist=off

errexit() {
    echo -e "$1" 1>&2
    exit
}

usuages() {
    cat <<EOF
A script to install fonts from same directory or another directory.
EX: 

    pai@supuraito ~/Downloads/CSChatThai $ pwd
    /home/pai/Downloads/CSChatThai
    pai@supuraito ~/Downloads/CSChatThai $ ls
    CSChatThai.ttf	CSChatThaiUI.ttf  insfont.sh
    pai@supuraito ~/Downloads/CSChatThai $ sudo ./insfont.sh -u

To install to bin, run "sudo install -m 777 ./insfont.sh /bin/insfont"

	-d | --directory : install fonts from another directory.
	-h | --help	 : print usuages.
	-u | --update	 : update fonts list. (fc-cache -f -v)
EOF
}

if [ $1 ]; then
    while true; do
	case $1 in
	    -d|--directory)
		cd $2
		shift 2
		;;
	    -h|--help|--usuage)
		usuages
		exit
		;;
	    -u|--update)
		upfontlist=on
		shift
		;;	    
	    *)
		if [ ! $1 ]; then
		    break
		else
		    usuages
		    exit
		fi
		;;
	esac
    done
fi

if [ $UID = 0 ]; then
    if [ ! -d $FONTDIR/TTF ]; then
	mkdir $FONTDIR/TTF
    elif [ ! -d $FONTDIR/OTF ]; then
	mkdir $FONTDIR/OTF
    fi
else
    if [ ! -d $FONTDIR/TTF ]|| [ ! -d $FONTDIR/OTF ]; then
	errexit "can't create directory. or don't have directory. ($FONTDIR/TTF | $FONTDIR/OTF)"
    fi
fi

cat <<EOF
Fonts list : 
$(find *.ttf *.otf 2> /dev/null)

EOF

if [ $UID = 0 ]; then
    for i in $(find *.ttf 2> /dev/null); do
	mv $i $FONTDIR/TTF
    done
    for i in $(find *.otf 2> /dev/null); do
	mv $i $FONTDIR/OTF
    done
else
    errexit "can't to install fonts to $FONTDIR. because don't have root permission." 
fi

[ $upfontlist = on ]&& fc-cache -f -v
