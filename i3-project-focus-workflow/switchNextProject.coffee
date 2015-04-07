exec = require('child_process').exec
_ = require 'lodash'
nf = require './necessaryFuncs'

exec('i3-msg -t get_workspaces', (error, stdout, stderr) ->
  wkList = JSON.parse(stdout)

  allOutputs = nf.getListOfOutputs(wkList)

  allWKNames = nf.getWKNames(wkList)

  allProjs = nf.getListOfProjects(wkList)
  console.log allProjs
)
