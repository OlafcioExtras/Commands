#!/usr/bin/env bash
echo "Commands"
trap "" SIGINT

read -t 2 -n 1;
case $REPLY in
	"l" | "L")
		echo "You want to load operating system state."
		echo -n "System directory: "
		read PDIR;
		CSD="yes" # CSD - Custom System Directory
	;;
	"r" | "R")
		echo "WARNING: You are about to reset your system."
		echo "Clicking key R on start making this happens."
		echo -n "Click any key to continue (to cancel resetting system click CTRL + Z)..."
		read -n 1;
		rm -Rv $HOME/.Commands
		echo "Resetted Commands operating system."
		sleep 1
	;;
esac
PNAME="Commands"
if [[ $CSD != "yes" ]]
then
	PDIR="$HOME/.Commands"
fi
PVER="1.1"
REGISTRIES="$PDIR/Registries"
UTEXT="default"
function checkreg() {
	if [[ $1 == "" ]]
	then
		echo "[CONSOLE/ERROR]: checkreg function: checkreg function don't know what registry to check"
		echo -n "Click any key to continue..."
		read -s -n 1;
		echo
	else
		if [[ -f "$REGISTRIES/$1.cmdreg" ]]
		then
			cat $REGISTRIES/$1.cmdreg
		else
			echo "[CONSOLE/ERROR]: checkreg function: registry $1 does not exists"
			read -s -n 1;
			echo
		fi
	fi
}
function setreg() {
	if [[ $1 == "" ]]
	then
		echo "[CONSOLE/ERROR]: setreg function: setreg function don't know what registry to set"
		echo -n "Click any key to continue..."
		read -s -n 1;
		echo
	else
		if [[ -f "$REGISTRIES/$1.cmdreg" ]]
		then
			if [[ $2 == "" ]]
			then
				echo "[CONSOLE/ERROR]: setreg function: setreg function don't know what is new value for registry"
				echo -n "Click any key to continue..."
				read -s -n 1;
				echo
			else
				echo "$2">$REGISTRIES/$1.cmdreg
			fi
		else
			echo "[CONSOLE/ERROR]: setreg function: registry $1 does not exists"
		fi
	fi
}
if [[ -d "$PDIR" ]]
then
	if [[ -d "$PDIR/Users" ]]
	then
		if [[ `ls $PDIR/Users` == "" ]]
		then
			UNAME="default"
		else
			UNAME="loggingin"
		fi
	else
		echo "User Account Profile cannot be loaded:"
		echo "System directory exists, but Users directory does not exists."
		echo "Setup $PNAME again to repair this."
	fi
fi
if [[ ! -d "$PDIR" ]]
then
	if [[ -f "$PDIR" ]]
	then
		echo "Setup exited because an error has occured:"
		echo "System directory arleady exists, but as a file"
		echo "System directory is $PDIR"
		exit 1
	fi
	clear
	echo "$PNAME Setup [Version $PVER]"
	echo
	echo "What is your name? (recommended: `whoami`)"
	echo -n "I'm "
	read UNAME;
	echo "What is your password? (include letters and symbols to make password hard to guess; making password empty is don't setting password, but recommended is setting password)"
	echo -n "My password is "
	read -s UPASS;
	echo
	echo "Setup is now installing $PNAME $PVER"
	echo
	echo
	echo
	mkdir $PDIR
	mkdir $PDIR/Users
	mkdir $PDIR/Users/$UNAME
	cd $PDIR/Users/$UNAME
	touch password
	echo "$UPASS">$password
	mkdir Desktop
	mkdir Documents
	mkdir Downloads
	mkdir Pictures
	mkdir Videos
	mkdir $PDIR/ProgramFiles
	mkdir $REGISTRIES
	touch $REGISTRIES/PauseOnStart.cmdreg
	echo "">$REGISTRIES/PauseOnStart.cmdreg
	echo
fi
function pause() {
	echo -n "Click any key to continue..."
	read -n 1 -s;
	if [[ $1 == "-c" || $1 == "--clear-after-entering" || $1 == "--clear" ]]
	then
		clear
	fi
}
if [[ `checkreg PauseOnStart` == "true" ]]
then
	pause
fi
while [ 1 ]
do
clear
echo -n "Username > "
read L1;
echo -n "Password > "
read -s L2;
echo
if [[ -d "$PDIR/Users" ]]
then
	if [[ `ls $HOME/.Commands/Users` == "" ]]
	then
		echo "There is no users."
		echo "Skipping login screen."
		pause -c
		break
	else
		if [[ -d "$PDIR/Users/$L1" ]]
		then
			if [[ -f "$PDIR/Users/$L1/password" ]]
			then
				if [[ $L2 == "`cat $HOME/.Commands/Users/$L1/password`" ]]
				then
					echo "Succesfuly logged in."
					break
				else
					echo "Bad password."
					pause
				fi
			else
				echo "You cannot log in to user $L1: password information does not exists."
				pause
			fi
		else
			echo "You cannot log in to user $L1: user does not exists."
			pause
		fi
	fi
else
	echo "User Account Profile cannot be loaded."
	echo "System directory exists, but Users directory does not exists."
	echo "Setup $PNAME again to repair this."
	pause
fi
done
clear
while [ 1 ]
do
	HOME="$PDIR/Users/$L1"
	if [[ $BREAKWH == "yes" ]]
	then
		BREAKWH=
		break
	fi
	temp=
	echo -n "$L1 `pwd`> "
	read cmd;
	case $cmd in
		"ls" | "l") ls -faq ;;
		"cd" | "c")
			echo "Enter directory path to enter:"
			read temp;
			cd $temp
		;;
		"crfile" | "crf")
			echo "Create file named:"
			read temp;
			if [[ -e "$temp" ]]
			then
				if [[ -f "$temp" ]]
				then
					echo "$temp file arleady exists"
				fi
				if [[ -d "$temp" ]]
				then
					echo "$temp arleady exists (as directory)"
				fi
			else
				touch $temp
				echo "$temp file created"
			fi
		;;
		"crdir" | "crd")
			echo "Create directory named:"
			read temp;
			if [[ -e "$temp" ]]
			then
				if [[ -f "$temp" ]]
				then
					echo "$temp directory arleady exists"
				fi
				if [[ -d "$temp" ]]
				then
					echo "$temp arleady exists (as file)"
				fi
			else
				mkdir $temp
				echo "$temp directory created"
			fi
		;;
		"shutdown" | "sd")
			echo "Goodbye!"
			BREAKWH="yes"
		;;
		"pause" | "pse") pause ;;
		"help" | "h")
			echo "This command is help (alias: h): Show all commands and help user that using PC now with using it"
			echo "Commands:"
			echo " + ls (alias: l): List files in your current directory"
			echo " + cd (alias: c): Enter to some directory"
			echo " + crfile (alias: crf): Create a file"
			echo " + crdir (alias: crd): Create a directory"
			echo " + shutdown (alias: sd): Turn off PC"
			echo " + pause (alias: pse): Make user click any key to continue"
		;;
		*) echo "Unkown command. Type \"help\" for help"
	esac
done
echo
echo
echo
echo "$PNAME $PVER"
echo "Turned off PC."
