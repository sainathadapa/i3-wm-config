exec = require('child_process').exec
_ = require 'lodash'
nf = require './necessaryFuncs'

exec('i3-msg -t get_workspaces', (error, stdout, stderr) ->
  wkList = JSON.parse(stdout)
  
  focWkName = nf.getFocusedWK(wkList)

  currentProjName = nf.getProjectFromWKName(focWkName)

  allProjectNames = nf.getListOfProjects(wkList)

  nextProjIndex = allProjectNames.indexOf(currentProjName)

  if nextProjIndex == -1
    return undefined
  if nextProjIndex == (allProjectNames.length-1)
    nextProjIndex = 0
  else
    nextProjIndex += 1

  nxtProjWks = nf.getWKNamesFromProj(wkList, allProjectNames[nextProjIndex])

  visWks = nf.getVisibleWKs(wkList)

  wksToMakeVisible = _.difference(nxtProjWks, visWks)

  parCommToRun = _.map(wksToMakeVisible, (x) -> 'workspace ' + x)

  commandToRun = "i3-msg '" + parCommToRun.join('; ') + "'"

  exec commandToRun

)
