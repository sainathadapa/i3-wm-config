_ = require('lodash')

getValidWorkspaceNums = (wkList, num) ->
  num = +num
  wkNums = _.pluck(wkList,'num')
  if wkNums.length == 0
    return(undefined)
  maxWKNum = _.max(wkNums)
  fullWKNums = [0..maxWKNum]
  goodWKNums  = _.difference(fullWKNums, wkNums)
  if num <= goodWKNums.length
    return goodWKNums[0..(num-1)]
  else
    return goodWKNums.concat ([(maxWKNum + 1)..(maxWKNum + num - goodWKNums.length)])

getListOfOutputs = (wkList) ->
  _.uniq(_.pluck(wkList, 'output'))

getWKNames = (wkList) ->
  _.uniq(_.pluck(wkList, 'name'))

getFocusedWK = (wkList) ->
  _.filter(wkList, (x) ->
    return (x.focused == true))[0].name

getVisibleWKs = (wkList) ->
  ans = _.filter(wkList, (x) ->
    return (x.visible == true))
  _.pluck(ans,'name')

getWorkspacesOnOutput = (wkList, outputName) ->
  filteredObj = _.filter(wkList, (y) ->
    return (y.output == outputName)
  )
  _.pluck(filteredObj, 'name')

getListOfProjects = (wkList) ->
  wknames = getWKNames(wkList)
  wknamesWithProject = _.filter(wknames, (x) ->
    x.indexOf("★") > -1
  )
  projectnames = _.map(wknamesWithProject, (x) ->
    getProjectFromWKName(x)
  )
  projectnamesUniq = _.uniq(projectnames)
  _.sortBy(projectnamesUniq, (x) -> x)

getProjectFromWKName = (wkName) ->
  re = /^\d+:★(.*)★\d+$/
  if  wkName.indexOf("★") < 0
    return undefined
  wkName.replace(re, '$1')

getWKNamesFromProj = (wkList, projName) ->
  wknames = getWKNames(wkList)
  projCorres = _.map(wknames, getProjectFromWKName)
  ansIndices = _.filter([0..(wknames.length-1)], (i) -> projCorres[i]==projName)
  ans = _.filter(wknames, (v, i) ->_.includes(ansIndices, i))
  _.sortBy(ans, (x) -> x)

getOutputForWK = (wkList, wkName) ->
  thiswk = _.filter(wkList, (x) -> x.name == wkName)[0]
  thiswk.output


module.exports = {getValidWorkspaceNums, getListOfOutputs,getFocusedWK, getWorkspacesOnOutput,getListOfProjects,getWKNames,getProjectFromWKName,getWKNamesFromProj,getVisibleWKs,getOutputForWK}
