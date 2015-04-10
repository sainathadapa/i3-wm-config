exec = require('child_process').exec
_ = require 'lodash'
nf = require './necessaryFuncs'

exec('i3-msg -t get_workspaces', (error, stdout, stderr) ->
  wkList = JSON.parse(stdout)
  
  focWkName = nf.getFocusedWK(wkList)

  allProjectNames = nf.getListOfProjects(wkList)
  
  if allProjectNames.length == 0 || allProjectNames == undefined
    process.exit()

  currentProjName = nf.getProjectFromWKName(focWkName)

  if currentProjName == undefined
    nextProjIndex = 0
  else
    nextProjIndex = allProjectNames.indexOf(currentProjName)

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
