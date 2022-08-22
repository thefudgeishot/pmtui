clear
FILE=~/.config/archTUI/manager.txt
if test -f "$FILE"; then
	tput setaf 3; tput bold; echo "Config file loaded..."
	sleep 1
else
	mkdir ~/.config/archTUI/ &> /dev/null
	tput setaf 5; tput bold; echo "Please select a installed package manager."
	PM=$(gum choose "Yay" "Pacman" "Other...")
	if [[ "$PM" == "Yay" ]]; then
		clear
		tput setaf 5; tput bold; echo "Are you sure you want to use $PM?"
		gum confirm && echo "yay" >> $FILE || bash pmtui.sh
    	elif [[ "$PM" == "Pacman" ]]; then
		clear
		tput setaf 5; tput bold; echo "Are you sure you want to use $PM?"
    		gum confirm && echo "pacman" >> $FILE || bash pmtui.sh
    	elif [[ "$PM" == "Other..." ]]; then
		clear
		tput setaf 5; tput bold; echo "Please input your package manager command. (yay, pacman, etc.)"
		CPM=$(gum input --placeholder "Please ensure that no capital letters are used")
		clear
		tput setaf 5; tput bold; echo "Are you sure you want to use $CPM?"
		gum confirm && echo "$CPM" >> $FILE || bash pmtui.sh

    	fi
fi
COMMAND=$(cat $FILE)
clear
tput setaf 5; tput bold; echo "Updating repo's..."
$COMMAND -Sy &> /dev/null
clear
tput setaf 4; tput bold; base64 -d <<<"H4sIAAAAAAAAA1OIJw1w1SiQBmpAOh5N60BDSGIgVSgcLMqhkuga4AJItqBLYtgHs0VBAdM8vCZj
Mw/VWEpMR9WDTlNuIjobhYfHgyATSUwk8DTCBYQAlTY03GICAAA=" | gunzip
tput setaf 5; tput bold; echo "Please select an operation. (Current package manager = $COMMAND)"
SELECTION=$(gum choose "Install" "Remove" "View Local Packages" "Full System Upgrade" "Change Package Manager" "Exit")
if [[ "$SELECTION" == "Install" ]]; then
	clear
	tput setaf 5; tput bold; echo "Select package to install from list."
	PACKAGE=$($COMMAND -Qq | gum filter)
	$COMMAND -S "$PACKAGE"
	sleep 2
	bash pmtui.sh
elif [[ "$SELECTION" == "Remove" ]]; then
	clear
	tput setaf 5; tput bold; echo "Select package to remove from list."
	PACKAGE=$($COMMAND -Qm | gum filter)
	FIXPACKAGE=$(echo $PACKAGE | sed 's/\s.*$//')
	$COMMAND -R "$FIXPACKAGE"
	sleep 2
	bash pmtui.sh	
elif [[ "$SELECTION" == "View Local Packages" ]]; then
	clear
	tput setaf 5; tput bold; echo "View packages from list."
	PACKAGE=$($COMMAND -Qm | gum filter)
	tput setaf 4; echo "$PACKAGE" | xclip -selection clipboard
        tput setaf 4; echo "$PACKAGE has been added to clipboard."	
	sleep 2
	bash pmtui.sh
elif [[ "$SELECTION" == "Full System Upgrade" ]]; then
	clear
	$COMMAND -Syu
	sleep 2
	bash pmtui.sh
elif [[ "$SELECTION" == "Change Package Manager" ]]; then
	clear
	tput setaf 5; tput bold; echo "Are you sure you want to remove $COMMAND as your package manager?"
	gum confirm && rm -rf $FILE || tput setaf 5; tput bold; echo "Package manager not deleted." && sleep 1
	bash pmtui.sh
elif [[ "$SELECTION" == "Exit" ]]; then
	clear
fi


