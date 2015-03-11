This repo contains my configuration for I3 window manager.

Notes:
- $mod key is Mod4 (windows key on most keyboards)
- A project is a set of workspaces with the format - (workspace-number):★(project-name)★(somenumber)
- i3blocks, rofi, nodejs are prerequisites.

Shortcuts:

| Key | Purpose |
| --- | ------- |
| $mod+Return | gnome-terminal |
| F4 | Kill the focused window |
| F10 | execute i3-dmenu-desktop |
| $mod+Left(Down,Up,Right) | focus left(down, up, right) window|
| $mod+Left(Down,Up,Right) | move focused window left (down, up, right)|
| $mod+h | Split the current container horizontally |
| $mod+v | Split the current container vertically |
| $mod+f | Fullscreen mode for the focused container |
| $mod+e | Toggle the layout of the focused container |
| $mod+space | Toggle floating status of the focused container |
| $mod+a | Focus parent container |
| $mod+d | Focus child container |
| $mod+(1-9,0) | Switch to workspaces with number 1-10 |
| $mod+Shift+(1-9,0) | Move the container to the workspaces with number 1-10 |
| $mod+Shift+c | Reload configuration file |
| $mod+Shift+r | Restart I3 inplace |
| $mod+Shift+e | Log out |
| $mod+r | Activate resize mode |
| $mod+z | Show scratchpad |
| $mod+Shift+z | Move container to scratchpad |
| XF86Calculator (calculator key) | gnome-calculator |
| XF86AudioRaiseVolume  | Raise volume by 5% |
| XF86AudioLowerVolume  | Decrease volume by 5% |
| XF86AudioMute  | Mute volume |
| $mod+Shift+p | Start a new project |
| $mod+p | Switch to the next project |
| $mod+Tab | Focus the workspace on the next monitor of the current project |
| $mod+Shift+Tab | Shift all the workspaces of the current project to their next monitors respectively |
| $mod+Control+Tab | Move the focused container to the next workspace of the current project |
| $mod+n | Rename current project |

Instructions:
- git clone --recursive git@github.com:sainathadapa/i3-wm-config.git ~/.i3 (Note: backup your i3 config!)
- Install [rofi](https://davedavenport.github.io/rofi//INSTALL.html)
- Install [i3blocks](https://github.com/vivien/i3blocks)
- Install NodeJS and NPM (apt-get install nodejs npm)
- cd .i3/i3-project-focus-workflow/; npm install
- Done!

