# window-manager
A minimal i3m'ish styled window manager.  Attempts to mimic some of the functionality I like from the i3m windows manager.

This is a tool I developed for myself without the intention of releasing to a larger audience but it works for the most part and a few people have expressed interest.

## Features
 - Dual monitor support @ 1920x1080 on each monitor
 - Grow and shrink windows
 - Center window on screen (scaled to 80%)
 - Position windows in 4 quadrant grid (shown below)
 - Snap left window / snap right
 - Snap top 50% of monitor / snap bottom 50% of monitor

## Requirements

You need to have AHK installed, specifically the version used to build the exe in this folder is 1.1.32.

To make the ahk script executable run `build.bat` by double clicking it or by running the following:

```powershell
#launch the build script, will output window-manager.exe to current directory
powershell.exe ./build.bat
```

Supported arguments to `window-manager.exe`:

```powershell
window-manager.exe
    --settop[left | right] #send command to position active window @ topleft of screen
    --setbottom[left | right] #send command to position active window @ bottom left of screen
    --set[left | right] #send command to snap window left or right
    --send[up | down | left | right] #send snap up, down, left or right
    --right #move to next virtual desktop
    --left #move to last virtual desktop
    --new #create a new virtual desktop
    --kill #destroy current virtual desktop
```