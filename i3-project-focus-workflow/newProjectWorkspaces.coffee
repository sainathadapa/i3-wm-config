'use strict'

exec = require('child_process').exec
_ = require('lodash')
nf = require('./necessaryFuncs')

mainFunction = (projectName) ->
  projectName = projectName.replace(/(\r\n|\n|\r)/gm,'')

  if (projectName == undefined || projectName.length == 0)
    return undefined

  exec('i3-msg -t get_workspaces', (error, stdout, stderr) ->
    wkList = JSON.parse(stdout)

    allOutputs = nf.getListOfOutputs(wkList)

    newWorkspaceNums = nf.getValidWorkspaceNums(wkList, allOutputs.length)
    console.log(newWorkspaceNums)

    oneWKForOneOut = allOutputs.map((x) ->
      ans = _.filter(wkList, (y) ->
        return (y.output == x)
      )
      return ans[0].name
    )

    maxWk = _.max(_.pluck(wkList,'num'))

    commandToRun = ''

    wkPrefix = '★' + projectName.toUpperCase()

    focusedWK = _.filter(wkList, (x) ->
      return (x.focused == true)
    )

    focusedWK = focusedWK[0].name

    `
    for (var i = 1; i <= allOutputs.length; i++) {
      // Steps:
      // 1. find a workspace which is on this output
      // 2. switch to it if it is already not focused
      // 3. create the new workspace

      var currentWKName = (maxWk + i) + ':' + wkPrefix + '★' + i;

      var commandToRun;

      if ((i != 1) || (oneWKForOneOut[i - 1] != focusedWK)) {
        commandToRun = commandToRun + 'workspace ' + oneWKForOneOut[i - 1] + '; ';
      }

      commandToRun = commandToRun + 'workspace ' + currentWKName + '; ';
    }
    `

    commandToRun = 'i3-msg "' + commandToRun + '"'

    # exec('zenity --notification --text=' + JSON.stringify(commandToRun))
    # console.log(commandToRun)

    exec(commandToRun)
  )

if(process.argv[2]==undefined)
  exec("zenity --entry --title=I3 --text='Start a new project with the name:'", (error1, stdout1, stderr1) -> mainFunction(stdout1))
else
  mainFunction(process.argv[2])


