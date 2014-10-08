#WS

**WS is a lightweight workspace manager for cli systems running bash**

## Contents
 - [How It Works] (#how-it-works)
 - [Installation] (#installation)
 - [Usage] (#usage)
   - [Writing a .ws file] (#writing-a-ws-file)
   - [Running a workspace] (#running-a-workspace)
 - [Configuration] (#configuration)
   - [Setting the editor command] (#setting-the-editor-command)

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
