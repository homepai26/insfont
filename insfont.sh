#!/bin/bash

FONTSDIR="/usr/share/fonts"
USER_LOCAL_FONTSDIR=~/.fonts

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

usuages() {
    cat <<EOF
insfont is a script to install fonts from current directory, or target directory, or target files.
 -d | --directory > Install fonts from THATS directory.		
 -f | --file > Install fonts by target THATS files. 
 -h | --help > Print usuages.
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
						shift 2
					fi
				;;

				-d|--directory)
				if [ $2 ]
					then
						find_fonts $2
						shift 2
					fi
				;;

				*)
				find_fonts $PWD
				for i in $FONTSLIST
					do
						if [ $UID == 0 ]
							then
								install_folder=$FONTSDIR
							else
								install_folder=$USER_LOCAL_FONTSDIR
						fi
						echo Moving $i to $install_folder/insfonts.
						if [ ! -d $install_folder/insfonts ]
							then
								echo "Not found $install_folder/insfonts, Making folder."
								mkdir -p $install_folder/insfonts
								if [ ! -d $install_folder/insfonts ]
									then
										errexit "Cannot new folder $install_folder/insfonts."										
								fi
						fi
						mv $i $install_folder/insfonts
					done
				if [ ! $i ]
					then usuages
					break
				fi 
				echo "Running fc-cache..."
				fc-cache -f -v > /dev/null
				break
		esac
done