_ = require('lodash')

getValidWorkspaceNums = (wkList, num) ->
  num = +num
  wkNums = _.pluck(wkList,'num')
  if wkNums.length == 0
    return(undefined)
  maxWKNum = _.max(wkNums)
  fullWKNums = [0..(maxWKNum-1)]
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

getWorkspacesOnOutput = (wkList, outputName) ->
  filteredObj = _.filter(wkList, (y) ->
    return (y.output == outputName)
  )
  _.pluck(filteredObj, 'name')

getListOfProjects = (wkList) ->
  re = /^\d+:★(.*)★\d+$/
  wknames = getWKNames(wkList)
  wknamesWithProject = _.filter(wknames, (x) ->
    x.indexOf("★") > -1
  )
  projectnames = _.map(wknamesWithProject, (x) ->
    x.replace(re, '$1')
  )
  projectnamesUniq = _.uniq(projectnames)
  _.sortBy(projectnamesUniq, (x) -> x)

module.exports = {getValidWorkspaceNums, getListOfOutputs,getFocusedWK, getWorkspacesOnOutput,getListOfProjects,getWKNames}
