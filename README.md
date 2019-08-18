This repo contains my custom configuration for [I3 tiling window manager](https://i3wm.org/).

Notes:
- $mod key is Mod4 (Windows key on most keyboards)
- A project is a set of workspaces with the format - `(workspace-number)::(project-name):(somenumber)`. Read more at [i3-wm-multi-disp-scripts](https://github.com/sainathadapa/i3-wm-multi-disp-scripts).
- [py3status](https://py3status.readthedocs.io/en/latest/intro.html) and [rofi](https://github.com/DaveDavenport/rofi) are the main dependencies.

Instructions:
- Backup your i3 config!
- git clone --recursive git@github.com:sainathadapa/i3-wm-config.git ~/.i3
- Install all the dependencies
- Done!

Shortcuts:

| Key                                | Purpose                                                                             |
| ---                                | -------                                                                             |
| $mod + (1-9,0)                     | Switch to workspaces with number 1-10                                               |
| $mod + Shift + (1-9,0)             | Move the container to the workspaces with number 1-10                               |
| $mod + h (j, k, l)                 | focus left (down, up, right) window                                                 |
| $mod + Shift + h (j, k, l)         | move focused window left (down, up, right)                                          |
| $mod + Return                      | terminal                                                                            |
| $mod + Shift + r                   | Restart I3 inplace                                                                  |
| $mod + r                           | Activate resize mode                                                                |
| $mod + space                       | Change focus between tiling and floating windows                                    |
| $mod + Shift + space               | Toggle floating status of the focused container                                     |
| $mod + a                           | Focus parent container                                                              |
| $mod + d                           | Focus child container                                                               |
| $mod + e                           | Toggle the layout of the focused container                                          |
| $mod + t                           | Split the current container horizontally                                            |
| $mod + y                           | Split the current container vertically                                              |
| $mod + f                           | Fullscreen mode for the focused container                                           |
| $mod + q                           | Lock the system                                                                     |
| $mod + z                           | Show scratchpad                                                                     |
| $mod + Shift + z                   | Move container to scratchpad                                                        |
| $mod + x                           | Toggle borders                                                                      |
| $mod + s                           | Toggle touchpad                                                                     |
| $mod + u                           | Create a floating video with explicit size, ideal for watching videos               |
| Print                              | Screenshot of the whole screen                                                      |
| $mod + Print                       | Select an area to screenshot                                                        |
| $mod + minus                       | Log-out, shutdown, etc menu                                                         |
| F4                                 | Kill the focused window                                                             |
| F7                                 | Rofi GUI to open a program                                                          |
| F8                                 | Opens a GUI for selecting a window, and the moves the selected window to the current workspace |
| F12                                | Rofi GUI to switch to a window                                                      |
| $mod + Shift + p                   | Start a new project                                                                 |
| $mod + p                           | Switch to the next project                                                          |
| $mod + o                           | Rename current project                                                              |
| $mod + Tab                         | Focus the workspace on the next monitor of the current project                      |
| $mod + Control + Tab               | Move the focused container to the next workspace of the current project             |
| $mod + Shift + Tab                 | Shift all the workspaces of the current project to their next monitors respectively |
