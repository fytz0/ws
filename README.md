#WS

**A lightweight workspace manager for cli systems running bash**

## Contents
 - [How It Works] (#how-it-works)
 - [Installation] (#installation)
 - [Usage] (#usage)
   - [Command line options] (#command-line-options)
   - [Writing a .ws file] (#writing-a-ws-file)
   - [Running a workspace] (#running-a-workspace)
 - [Configuration] (#configuration)
   - [Setting the editor command] (#setting-the-editor-command)
 - [Licensing] (#licensing)
 - [Contact & Bug Reports] (#contact-and-bug-reports)

##How it works
Each directory that you want to open a workspace from should contain a file
called '.ws'. This file defines 1 or more workspaces consisting of a group of
files and a name to associate with them. Running `ws` in a directory will
launch your chosen editor with the files defined in the default workspace open
or you can run `ws [WORKSPACE NAME]` to launch a specific collection of files.
For instance, if my .ws file defines a workspace named *headers* then I can
open my chosen editor with all of the files listed in *headers* by running
`ws headers`.

##Installation
An installation script is included in this repository for ease.

To install simply run `./install -i` in this directory.

To uninstall run `./install -u`.

##Usage
###Command line options
`ws -e` Edit the current directories .ws config file
`ws -p` Instead of running the final editor command, print it to stdout
`ws -h` Show a help dialog
`ws -v` Show the version dialog

Note that these four options also have long versions; --edit, --print, --help
and --version respectively.

###Writing a ws file
Each .ws file defines workspaces with the syntax:
```
NAME {
	FILE1
	FILE2
	ETC.
}
```

You can include as many workspaces in a file as you wish.

For instance, you can define a workspace named *gui* containing the files
gui.h, gui.c and guimacros.h like this:
```
gui {
	gui.h
	gui.c
	guimacros.h
}
```

###Running a workspace
Running `ws` in a directory without providing a workspace name on the command
line will open the default workspace which is defined in your .ws file with the
name *ws* like so:
```
ws {
	MY_FILE_1
	MY_FILE_2
}
```

Note that whitespace is not syntactically significant in .ws files so the
following three workspace definitions are synonymous:
```
ws {
	MY_FILE_1
	MY_FILE_2
}

ws
{
	MY_FILE_1
	MY_FILE_2
}

ws { MY_FILE_1 MY_FILE_2 }
```

Also note that if multiple workspaces in the same file are given the same name,
the FIRST definition will be launched.

##Configuration
When you install ws using the included *install.sh* script, it will create a
default configuration file at *~/.wsrc*. Currently, this file only has one
option (setting the editor command as described below), but it's scope may be
expanded in future releases.

###Setting the editor command
WS allows you to set your own editor command. The default is `vim -p` which
will launch your files in vim in seperate tabs. To change this, open *~/.wsrc*
and edit the field that reads `editor="vim -p"` to your preferred choice.

##Licensing
This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see http://www.gnu.org/licenses/.

##Contact and Bug Reports
Bug reports can be filled at https://github.com/o-jay/ws/issues

If you fix an issue or add new features please send a pull request and I'll be
more than happy to merge your changes.

If you have any issues you can contact me at *ojay@ojay.co.uk*
