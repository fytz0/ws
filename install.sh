#!/bin/bash

# Welcome message
echo "WS Installer Version 0.1.1"

# Files
src="ws.sh"
dest="/usr/bin/ws"
rcsrc="wsrc"
rcdest="$HOME/.wsrc"

# Manuals
man1="ws.1"
man5="wsrc.5"
mandir="/usr/share/man"

# Make sure we're NOT running as root - it messes up the $HOME variable
if [ -n "$SUDO_COMMAND" ]; then
	echo "Error: Don't run this script with sudo"
	exit 1
fi

# Install function - note that we only copy the rc if there isn't already one
# on the system
function install {
	if [ ! -f $rcdest ]; then
		cp $rcsrc $rcdest
	fi

	sudo cp $src $dest

	gzip -fk $man1 $man5

	sudo mv ${man1}.gz ${mandir}/man1
	sudo mv ${man5}.gz ${mandir}/man5

	echo Installation complete
}

# Uninstall function - note that we don't delete the rc
function uninstall {
	rm -rf $dest ${mandir}/man1/${man1}.gz ${mandir}/man5/${man5}.gz
	echo Uninstallation complete
}

# Print help function
function print_help {
	echo WS Installation script
	echo Options:
	echo "  -h, --help      Show this help messge"
	echo "  -i, --install   Install ws"
	echo "  -u, --uninstall Uninstall ws"
	echo Note that installing and uninstalling require root privileges
	exit 0
}

# Check uninstall flag
if [ $# != 1 ]; then
	echo Error: found $# arguments, expected 1
	print_help
else
	case $1 in
	-h|--help)
		print_help
		;;
	-i|--install)
		install
		;;
	-u|--uninstall)
		uninstall
		;;
	*)
		echo Unrecognized option: $1
		print_help
	esac
fi
