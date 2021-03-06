#!/bin/bash
# make by homepai26 - pai

FONTDIR=/usr/share/fonts
upfontlist="off"
auto_update="off"               # default is off
# if auto_update=on and don't have root permission
# it will be update only

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

	-d    | --directory  	      : install fonts from another directory.		
	-h    | --help	      	      : print usuages.
	-u    | --update	      : update fonts list. (fc-cache -f -v)
	      			      : if don't have root permission it will be
				      : update list only.
	-f    | --file		      : install font by target a file only one file.
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
	    -f|--file)
		FILE=$2*
		echo $FILE
		if [ ! -d /tmp/insfont ]; then
		    mkdir /tmp/insfont
		else
		    if [ ! -d /tmp/insfont ]; then
			errexit "can't create /tmp/insfont "
		    fi
		fi

		if [ ! $2 ]; then		   
		    errexit "EX: $0 -f opensans.ttf"
		fi
		
		
		if [ -d /tmp/insfont ]; then
		    cp $FILE /tmp/insfont  
		fi

		cd /tmp/insfont
		shift 2
		break
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
    if [ $upfontlist != "on" ]; then
	if [ $auto_update != "on" ]; then    
	    errexit "can't to install fonts to $FONTDIR. because don't have root permission." 
	else
	    echo "update fonts list only."
	fi
    fi
fi

if [ $upfontlist = on ]; then
    fc-cache -f -v
elif [ $auto_update = on ]; then
    fc-cache -f	-v
fi
