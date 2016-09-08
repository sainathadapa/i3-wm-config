This repo contains my custom configuration for [I3 tiling window manager](https://i3wm.org/).

Notes:
- $mod key is Mod4 (Windows key on most keyboards)
- A project is a set of workspaces with the format - (workspace-number):★(project-name)★(somenumber). Read more about this at [i3-project-focus-workflow](https://github.com/sainathadapa/i3-project-focus-workflow).
- [i3blocks](https://github.com/vivien/i3blocks), [rofi](https://github.com/DaveDavenport/rofi), and [nodejs](https://nodejs.org/en/) are the dependecies.

Instructions:
- Backup your i3 config!
- git clone --recursive git@github.com:sainathadapa/i3-wm-config.git ~/.i3
- Install [rofi](https://davedavenport.github.io/rofi//INSTALL.html)
- Install [i3blocks](https://github.com/vivien/i3blocks)
- Done!

Shortcuts:

| Key                        | Purpose                                                                             |
| ---                        | -------                                                                             |
| $mod + (1-9,0)             | Switch to workspaces with number 1-10                                               |
| $mod + Control + Tab       | Move the focused container to the next workspace of the current project             |
| $mod + Left(Down,Up,Right) | focus left(down, up, right) window                                                  |
| $mod + Left(Down,Up,Right) | move focused window left (down, up, right)                                          |
| $mod + Return              | gnome-terminal                                                                      |
| $mod + Shift + (1-9,0)     | Move the container to the workspaces with number 1-10                               |
| $mod + Shift + Tab         | Shift all the workspaces of the current project to their next monitors respectively |
| $mod + Shift + c           | Reload configuration file                                                           |
| $mod + Shift + e           | Log out                                                                             |
| $mod + Shift + p           | Start a new project                                                                 |
| $mod + Shift + r           | Restart I3 inplace                                                                  |
| $mod + Shift + space       | Change focus between tiling and floating windows                                    |
| $mod + Shift + z           | Move container to scratchpad                                                        |
| $mod + Tab                 | Focus the workspace on the next monitor of the current project                      |
| $mod + a                   | Focus parent container                                                              |
| $mod + d                   | Focus child container                                                               |
| $mod + e                   | Toggle the layout of the focused container                                          |
| $mod + f                   | Fullscreen mode for the focused container                                           |
| $mod + h                   | Split the current container horizontally                                            |
| $mod + l                   | Lock the system                                                                     |
| $mod + n                   | Rename current project                                                              |
| $mod + p                   | Switch to the next project                                                          |
| $mod + r                   | Activate resize mode                                                                |
| $mod + space               | Toggle floating status of the focused container                                     |
| $mod + v                   | Split the current container vertically                                              |
| $mod + z                   | Show scratchpad                                                                     |
| F10                        | execute i3-dmenu-desktop                                                            |
| F12                        | Rofi GUI to switch to a window                                                      |
| F4                         | Kill the focused window                                                             |
| F8                         | Change window title of the focused window                                           |
| F9                         | Rofi GUI to open a program                                                          |
