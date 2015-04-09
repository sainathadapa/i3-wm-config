exec = require('child_process').exec
_ = require('lodash')
nf = require './necessaryFuncs.coffee'

exec('i3-msg -t get_workspaces',  (error, stdout, stderr) ->
  wkList = JSON.parse(stdout)

  allWKNames = nf.getWKNames(wkList)

  fcsWK = nf.getFocusedWK(wkList)

  currentProj = nf.getProjectFromWKName(fcsWK)

  if currentProj == undefined or currentProj.length == 0
    return undefined

  currentProjWKs = nf.getWKNamesFromProj(wkList,currentProj)

  currentProjWKOutputs = _.map(currentProjWKs, (x) ->
    nf.getOutputForWK(wkList, x))

  newOutputPos =  [1..currentProjWKs.length]

  newOutputPos = newOutputPos.map((x) ->
    if (x == currentProjWKOutputs.length)
      x = 0
    return x
  )

  newOutputs = newOutputPos.map((i) -> currentProjWKOutputs[i])

  parCommToRun = _.map(currentProjWKs, (x,i) ->
    ans = ''
    if (i != 0) || (currentProjWKs[i] != nf.getFocusedWK(wkList))
      ans += 'workspace ' + currentProjWKs[i] + '; '
    ans += 'move workspace to output ' + newOutputs[i] + '; ')

  commandToRun = "i3-msg '" + parCommToRun.join('') + "'"

  exec commandToRun
)
