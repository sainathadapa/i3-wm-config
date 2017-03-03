# -*- coding: utf-8 -*-
# quickswitch for i3 - quickly change to and locate windows in i3.
#
# Author: slowpoke <mail+python at slowpoke dot io>
# This program is Free Software under the terms of the
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

import argparse
import subprocess
import os
import re

try:
    import i3
except ImportError:
    print("quickswitch requires i3-py.")
    print("You can install it from the PyPI with ``pip install i3-py''.")
    exit(1)


def check_dmenu():
    '''Check if dmenu is available.'''
    devnull = open(os.devnull)
    retcode = subprocess.call(["which", "dmenu"],
                              stdout=devnull,
                              stderr=devnull)
    return True if retcode == 0 else False


def dmenu(options, dmenu):
    '''Call dmenu with a list of options.'''

    cmd = subprocess.Popen(dmenu,
                           shell=True,
                           stdin=subprocess.PIPE,
                           stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE)
    stdout, _ = cmd.communicate('\n'.join(options).encode('utf-8'))
    return stdout.decode('utf-8').strip('\n')


def get_windows():
    '''Get all windows.'''
    windows = i3.filter(nodes=[])
    return create_lookup_table(windows)


def find_window_by_regex(regex, move=False):
    '''Find the first window whose title matches regex and focus or move it.'''
    action = move_window_here if move else focus

    cr = re.compile(regex)
    for title, id in get_windows().items():
        if cr.match(title):
            action(id)
            return True
    return False


def get_scratchpad():
    '''Get all windows on the scratchpad.'''
    scratchpad = i3.filter(name="__i3_scratch")[0]
    nodes = scratchpad["floating_nodes"]
    windows = i3.filter(tree=nodes, nodes=[])
    return create_lookup_table(windows)


def get_workspaces():
    '''Returns all workspace names.

    NOTE: This returns a map of name → name, which is rather redundant, but
    makes it possible to use the result without changing much in main().
    '''
    workspaces = i3.get_workspaces()
    for ws in workspaces:
        # create_lookup_table will set the value of all entries in the lookup table
        # to the window id. We act as if the workspace name is the window id.
        ws['window'] = ws['name']
    return create_lookup_table(workspaces)


def next_empty():
    '''Return the lowest numbered workspace that is empty.'''
    workspaces = sorted([int(ws) for ws in get_workspaces().keys()
                         if ws.isdecimal()])
    for i in range(len(workspaces)):
        if workspaces[i] != i + 1:
            return str(i + 1)
    return str(len(workspaces) + 1)


def next_used(number):
    '''Return the next used numbered workspace after the given number.'''
    workspaces = sorted([int(ws) for ws in get_workspaces().keys()
                         if ws.isdecimal()
                         and int(ws) > number])
    return workspaces[0] if workspaces else None


def degap():
    '''Remove 'gaps' in the numbered workspaces.

    This searches for non-consecutive numbers in the workspace list, and moves
    used workspaces as far to the left as possible.

    '''
    i = 0
    while True:
        ws = next_used(i)
        if ws is None:
            break
        elif ws - i > 1:
            rename_workspace(ws, i + 1)
        i += 1


def create_lookup_table(windows):
    '''Create a lookup table from the given list of windows.

    The returned dict is in the format window title → X window id.
    '''
    rename_nonunique(windows)
    lookup = {}
    for window in windows:
        name = window.get('name')
        id_ = window.get('window')
        if id_ is None:
            # this is not an X window, ignore it.
            continue
        if name.startswith("i3bar for output"):
            # this is an i3bar, ignore it.
            continue
        lookup[name] = id_
    return lookup


def rename_nonunique(windows):
    '''Rename all windows which share a name by appending an index.'''
    window_names = [window.get('name') for window in windows]
    for name in window_names:
        count = window_names.count(name)
        if count > 1:
            for i in range(count):
                index = window_names.index(name)
                window_names[index] = "{} [{}]".format(name, i + 1)
    for i in range(len(windows)):
        windows[i]['name'] = window_names[i]


def get_scratchpad_window(window):
    '''Does `scratchpad show` on the specified window.'''
    return i3.scratchpad("show", id=window)


def move_window_here(window):
    '''Does `move workspace current` on the specified window.'''
    return i3.msg(0, "{} move workspace current".format(
        i3.container(id=window)))


def rename_workspace(old, new):
    '''Rename a given workspace.'''
    return i3.msg(0, "rename workspace {} to {}".format(old, new))


def focus(window):
    '''Focuses the given window.'''
    return i3.focus(id=window)


def goto_workspace(name):
    '''Jump to the given workspace.'''
    return i3.workspace(name)


def get_current_workspace():
    '''Get the name of the currently active workspace.'''
    filtered = [ws for ws in i3.get_workspaces() if ws["focused"] is True]
    return filtered[0]['name'] if filtered else None


def cycle_numbered_workspaces(backwards=False):
    '''Get the next (previous) numbered workspace.'''
    current = get_current_workspace()
    if not current.isdecimal():
        return None
    i = int(current)
    return str(i + 1) if not backwards else str(i - 1)


lookup_func = get_windows
action_func = move_window_here

lookup = lookup_func()
target = dmenu(lookup.keys(), '/usr/bin/dmenu -b -i -l 20')
id_ = lookup.get(target)
success = action_func(lookup.get(target)) if id_ is not None else False

exit(0 if success else 1)
