#!/usr/bin/python3
# -*- coding: utf-8 -*-
import subprocess
import json
import sys
import re
from necessaryFuncs import *

proc_out = subprocess.run(['i3-msg', '-t', 'get_workspaces'], stdout=subprocess.PIPE)
wkList = json.loads(proc_out.stdout.decode('utf-8'))

allWKNames = getWKNames(wkList)

internalDisplay = 'eDP-1-1'
externalDisplays = [x for x in getListOfOutputs(wkList) if x != internalDisplay]
eachProjectWks = [getWKNamesFromProj(wkList, x) for x in getListOfProjects(wkList)]

for eachProject in eachProjectWks:
  for i, x in enumerate(eachProject[1:]):
    commandToRun = 'workspace --no-auto-back-and-forth ' + x + '; ' + 'move workspace to output ' + externalDisplays[i] + '; '
    commandToRun = ['i3-msg', commandToRun]
    subprocess.call(commandToRun)


