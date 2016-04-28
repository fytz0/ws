#!/bin/bash

# The ws workspace manager
# Copyright 2014-2016 Ollie Etherington
# Free software under the GNU GPLv3

# Info
NAME="WS"
DESCRIPTION="The Workspace Manager"
VERSION="0.1.3"
COPYRIGHT="Copyright 2014-2016 Ollie Etherington"
WEBSITE="github.com/oetherington/ws"
LICENSE="Free software under the terms of the GNU GPLv3"

# Program data
RUNCMD=${EDITOR:="vim -p"}	# Get the EDITOR env var if it exists, else set it
RC="$HOME/.wsrc"	# Global RC config
CFG=".ws"			# Local definitions#tokens=( `cat ${CFG} | tr ' ' '\n'` )
DEFAULT_WS="ws"		# The default workspace

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
		default_ws)
			DEFAULT_WS="${value//\"/}"
			;;
		*)
			echo "Warning: Unrecognized config option '$rcvar' in '$RC'"
			;;
		esac
	done < $RC
fi

# The workspace to run
WS=$DEFAULT_WS

# Restore the internal field seperator for later
IFS=$backupIFS

# Parse command line arguments
echo_cmd=false
list_ws=false
using_custom_ws_name=false
argv=( $@ )
argc=$#

# Help message
function print_help {
	echo $NAME - $DESCRIPTION
	echo $WEBSITE
	echo "Usage: ws [WORKSPACE NAME] [OPTIONS]..."
	echo Save common file groups to directory specific workspaces and associate
	echo them with an editor command
	echo The following options may be used:
	echo "  -h,--help     Show this help message"
	echo "  -v,--version  Show version information"
	echo "  -e,--edit     Edit the current directories .ws file"
	echo "  -p,--print    Instead of executing the run command, print it"
	echo "  -l,--list     List the available workspaces"
	exit 0
}

# Version info
function print_version {
	echo $NAME - $DESCRIPTION
	echo Version $VERSION
	echo $WEBSITE
	echo $COPYRIGHT
	echo $LICENSE
	exit 0
}

# Edit this directories workspace definition file
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
	-l|--list)
		list_ws=true
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

# If we're listing the workspaces, do that and then exit
if [ $list_ws == true ]; then
	i=0
	while [ $i -lt $max_token ]; do
		# Get the workspace name
		WS=${tokens[i]}

		((i++))

		# Check is we're using a custom editor command
		if [ ${tokens[i]} == "-" ]; then
			((i++))

			EDITOR_CMD=${tokens[i]}

			# If it's multiple tokens in quotes we need to get the rest
			if [[ $EDITOR_CMD == \"* ]]; then
				while [[ $EDITOR_CMD != *\" ]]; do
					((i++))
					EDITOR_CMD="$EDITOR_CMD ${tokens[i]}"
				done
			fi

			# Remove the actual quotes from the string
			EDITOR_CMD=`echo $EDITOR_CMD | sed 's/^"\(.*\)"$/\1/'`

			((i++))
		else
			EDITOR_CMD=$RUNCMD
		fi

		# Print the name and editor command
		echo "$WS (Command: $EDITOR_CMD)"

		# Make sure we have a list of files
		if [ ${tokens[i]} != "{" ]; then
			echo "Syntax Error: Expected '{' found '${tokens[i]}'"
			exit 0
		fi

		((i++))

		# We do - get them
		while [ ${tokens[i]} != "}" ]; do
			# Make sure we're still in bounds
			if [ $i == $max_token ]; then
				echo "Syntax Error: Expected '}' found EOF"
				exit 0
			fi

			echo "  - ${tokens[i]}"

			((i++))
		done

		((i++))
	done

	exit 0
fi

# Do the parsing
for i in `seq 0 $max_token`; do
	# Only bother properly parsing the workspace we actually want to open
	if [ ${tokens[i]} == $WS ]; then
		ws_not_found=false

		((i++))

		# Check if this workspace has a custom editor command
		if [ ${tokens[i]} == "-" ]; then
			((i++))

			# It does - get it
			NEWCMD=${tokens[i]}

			# If it's multiple tokens in quotes we need to get the rest
			if [[ $NEWCMD == \"* ]]; then
				while [[ $NEWCMD != *\" ]]; do
					((i++))
					NEWCMD="$NEWCMD ${tokens[i]}"
				done
			fi

			# Remove the actual quotes from the string
			NEWCMD=`echo $NEWCMD | sed 's/^"\(.*\)"$/\1/'`

			# Set the editor command
			RUNCMD=$NEWCMD

			((i++))
		fi

		# Make sure we have a list of files
		if [ ${tokens[i]} != "{" ]; then
			echo "Syntax Error: Expected '{' found '${tokens[i]}'"
			exit 0
		fi

		((i++))

		# We do - get them
		while [ ${tokens[i]} != "}" ]; do
			# Make sure we're still in bounds
			if [ $i == $max_token ]; then
				echo "Syntax Error: Expected '}' found EOF"
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

# Start the workspace (or echo it...)
if $echo_cmd; then
	echo $RUNCMD $file_hook
else
	$RUNCMD $file_hook
fi
