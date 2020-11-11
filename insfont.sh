#!/bin/bash
# make by homepai26 - pai

FONTDIR=/usr/share/fonts

errexit() {
    echo -e "$1" 1>&2
    exit
}

usuages() {
    cat <<EOF
A script to install fonts from same directory.



	-d | --directory : install fonts from another directory.
EOF
}

if [ $1 ]; then
    while true; do
	case $1 in
	    -d|--directory)
		cd $2
		break
		;;
	    -h|--help|--usuage)
		usuages
	   	exit
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
    errexit "\ncan't to install fonts to $FONTDIR. because don't have root permission." 
fi
