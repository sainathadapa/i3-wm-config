#!/usr/bin/python3
# -*- coding: utf-8 -*-
import subprocess
import json
from i3_wm_multi_disp_scripts import necessaryFuncs as nf

proc_out = subprocess.run(['i3-msg', '-t', 'get_workspaces'], stdout=subprocess.PIPE)
wkList = json.loads(proc_out.stdout.decode('utf-8'))

allWKNames = nf.getWKNames(wkList)

internalDisplay = 'eDP-1-1'

wksOnExternalDisplays = [x['name'] for x in wkList if x['output'] != internalDisplay]

commandToRun = ''.join(['workspace --no-auto-back-and-forth ' +
                        x + '; ' +
                        'move workspace to output ' +
                        internalDisplay + '; ' for x in wksOnExternalDisplays])

commandToRun = ['i3-msg', commandToRun]

subprocess.call(commandToRun)
