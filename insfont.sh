#!/bin/bash

FONTSDIR="/usr/share/fonts"
USER_LOCAL_FONTSDIR=~/.local/share/fonts
IS_SELECT_FONT=0

errexit() {
    echo -e "\033[0;31mError!\033[0m $1" 1>&2
    exit
}

target_font() {
    if [ -f $1 ]; then FONTSLIST="$FONTSLIST $1"; fi
}

find_fonts() {
    directory=$1
    FONTSLIST="$FONTSLIST $(find $directory/*.ttf 2> /dev/null)"
    FONTSLIST="$FONTSLIST $(find $directory/*.otf 2> /dev/null)"
}

create_directory() {
    echo "Not found $install_folder/insfonts, Making folder."
    mkdir -p $install_folder/insfonts
    
    if [ ! -d $install_folder/insfonts ]
    then
	errexit "Cannot new folder $install_folder/insfonts."
    fi
}

usages() {
    cat <<EOF
insfont is a script to install fonts from current directory, or target
directory, or target file.

Possible flags are:
 -d, --directory dir          Install multiple fonts from THAT directory.
 -f, --file *.[ttf,otf]       Install single font by target THAT file.
 -h, --help                   Print usages.
EOF
}

while true
do
    case $1
    in
	-h|--help)
	    usuages
	    break
	    ;;
	
	-f|--file)
	    if [ $2 ]
	    then 
		target_font $2
		IS_SELECT_FONT=1
		shift 2
	    fi
	    ;;
	
	-d|--directory)
	    if [ $2 ]
	    then
		find_fonts $2
		IS_SELECT_FONT=1
		shift 2
	    fi
	    ;;
	
	*)
	    # do not searching, if have been specified to-go *font* already.
	    if [ $IS_SELECT_FONT == 0 ]
	    then
		find_fonts $PWD
	    fi
	    
	    if [ $UID == 0 ]
	    then
		install_folder=$FONTSDIR
	    else
		install_folder=$USER_LOCAL_FONTSDIR
	    fi
	    
	    if [ ! -d $install_folder/insfonts ]
	    then
		create_directory
	    fi

	    for i in $FONTSLIST
	    do
		echo Moving $i to $install_folder/insfonts.		
		mv $i $install_folder/insfonts
	    done
	    
	    if [ ! $i ]
	    then
		usages
		break
	    fi
	    
	    echo "Running fc-cache..."
	    fc-cache -f -v > /dev/null
	    break
    esac
done
