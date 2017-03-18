This repo contains my custom configuration for [I3 tiling window manager](https://i3wm.org/).

Notes:
- $mod key is Mod4 (Windows key on most keyboards)
- A project is a set of workspaces with the format - (workspace-number):★(project-name)★(somenumber). Read more about this at [i3-project-focus-workflow](https://github.com/sainathadapa/i3-project-focus-workflow).
- [i3blocks](https://github.com/vivien/i3blocks) and [rofi](https://github.com/DaveDavenport/rofi) are the dependecies.

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
| $mod + Shift + (1-9,0)     | Move the container to the workspaces with number 1-10                               |
| $mod + Left(Down,Up,Right) | focus left(down, up, right) window                                                  |
| $mod + Shift+ Left(Down,Up,Right) | move focused window left (down, up, right)                                   |
| $mod + Return              | terminal                                                                            |
| $mod + Shift + e           | Log out                                                                             |
| $mod + Shift + r           | Restart I3 inplace                                                                  |
| $mod + r                   | Activate resize mode                                                                |
| $mod + Shift + space       | Toggle floating status of the focused container                                     |
| $mod + space               | Change focus between tiling and floating windows                                    |
| $mod + a                   | Focus parent container                                                              |
| $mod + d                   | Focus child container                                                               |
| $mod + e                   | Toggle the layout of the focused container                                          |
| $mod + f                   | Fullscreen mode for the focused container                                           |
| $mod + h                   | Split the current container horizontally                                            |
| $mod + v                   | Split the current container vertically                                              |
| $mod + l                   | Lock the system                                                                     |
| $mod + Shift + p           | Start a new project                                                                 |
| $mod + p                   | Switch to the next project                                                          |
| $mod + n                   | Rename current project                                                              |
| $mod + Tab                 | Focus the workspace on the next monitor of the current project                      |
| $mod + Control + Tab       | Move the focused container to the next workspace of the current project             |
| $mod + Shift + Tab         | Shift all the workspaces of the current project to their next monitors respectively |
| $mod + Shift + z           | Move container to scratchpad                                                        |
| $mod + z                   | Show scratchpad                                                                     |
| $mod + x                   | Toggle borders                                                                      |
| F4                         | Kill the focused window                                                             |
| F8                         | Opens a GUI for selecting a window that needs to be moved to the current workspace  |
| F9                         | Rofi GUI to open a program                                                          |
| F10                        | Rofi GUI to open a program                                                          |
| F12                        | Rofi GUI to switch to a window                                                      |
