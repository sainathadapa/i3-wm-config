exec = require('child_process').exec
_ = require('lodash')
nf = require './necessaryFuncs.coffee'

exec('i3-msg -t get_workspaces',  (error, stdout, stderr) ->
  wkList = JSON.parse(stdout)

  allWKNames = nf.getWKNames(wkList)

  currentWK = nf.getFocusedWK(wkList)

  currentProj = nf.getProjectFromWKName(currentWK)

  if currentProj == undefined
    return undefined

  currentProjWKs = nf.getWKNamesFromProj(wkList, currentProj)
  
  thisWKPos = currentProjWKs.indexOf(currentWK)

  if thisWKPos == -1
    return undefined

  newWKPos = thisWKPos + 1
  if newWKPos == currentProjWKs.length
    newWKPos = 0

  commandToRun = 'i3-msg "workspace ' + currentProjWKs[newWKPos] + '"'

  exec commandToRun
)
