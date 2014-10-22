#!/bin/bash

# The ws workspace manager
# Copyright 2014 Ollie Etherington
# Free software under the GNU GPLv3

# Info
NAME="WS"
DESCRIPTION="The Workspace Manager"
VERSION="0.0.1"
COPYRIGHT="Copyright 2014 Ollie Etherington"
LICENSE="Free software under the terms of the GNU GPLv3"

# Program data
${EDITOR:="vim -p"}	# Get the EDITOR env var if it exists, else set it
RUNCMD=$EDITOR		# Command to run
RC="$HOME/.wsrc"	# Global RC config
CFG=".ws"			# Local definitions#tokens=( `cat ${CFG} | tr ' ' '\n'` )
WS="ws"				# Workspace name

# Check for system config and process it if it exists
# Setup the internal field seperator for parsing
backupIFS=$IFS
IFS="="

if [ -f $RC ]; then
	while read -r rcvar value; do
		case $rcvar in
		editor)
			RUNCMD="${value//\"/}"
			;;
		*)
			echo "Warning: Unrecognized config option '$rcvar' in '$RC'"
			;;
		esac
	done < $RC
fi

# Restore the internal field seperator for later
IFS=$backupIFS

# Parse command line arguments
echo_cmd=false
using_custom_ws_name=false
argv=( $@ )
argc=$#

function print_help {
	echo $NAME - $DESCRIPTION
	echo "Usage: ws [WORKSPACE NAME] [OPTIONS]..."
	echo Save common file groups to directory specific workspaces and associate
	echo them with an editor command
	echo The following options may be used:
	echo "  -h,--help     Show this help message"
	echo "  -v,--version  Show version information"
	echo "  -e,--edit     Edit the current directories .ws file"
	echo "  -p,--print    Instead of executing the run command, print it"
	exit 0
}

function print_version {
	echo $NAME - $DESCRIPTION
	echo Version $VERSION
	echo $COPYRIGHT
	echo $LICENSE
	exit 0
}

function edit_spec {
	$RUNCMD $CFG
	exit 0
}

for i in `seq 0 $(($argc-1))`; do
	case "${argv[i]}" in
	-h|--help)
		print_help
		;;
	-v|--version)
		print_version
		;;
	-e|--edit)
		edit_spec
		;;
	-p|--print)
		echo_cmd=true
		;;
	*)
		if $using_custom_ws_name; then
			echo "Error: Multiple workspaces given ('$WS' and '${argv[i]}')"
			exit 0
		else
			WS=${argv[i]}
			using_custom_ws_name=true
		fi
		;;
	esac
done

# Ensure the workspace config file exists
if [ ! -f $CFG ]; then
	echo Workspace config file not found - exiting
	exit 0
fi

# Get workspace definition
definition=`cat ${CFG}`
tokens=( $definition )
num_tokens=${#tokens[@]}
max_token=$(($num_tokens-1))
ws_not_found=true
file_hook=""

# Do the parsing
for i in `seq 0 $max_token`; do
	if [ ${tokens[i]} == $WS ]; then
		ws_not_found=false

		((i++))

		if [ ${tokens[i]} != "{" ]; then
			echo "Syntax Error: Expected '{'"
			exit 0
		fi

		((i++))

		while [ ${tokens[i]} != "}" ]; do
			if [ $i == $max_token ]; then
				echo "Syntax Error: Expected '}'"
				exit 0
			fi

			file_hook="$file_hook ${tokens[i]}"

			((i++))
		done
	fi
done

# Check if we didn't find the workspace
if $ws_not_found; then
	echo "Workspace '$WS' not found - exiting"
	exit 0
fi

# Start the workspace
if $echo_cmd; then
	echo $RUNCMD $file_hook
else
	$RUNCMD $file_hook
fi
