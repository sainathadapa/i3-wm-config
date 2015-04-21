exec = require('child_process').exec
_ = require('lodash')
nf = require('./necessaryFuncs')

mainFunction = (projectName) ->
  # replace any new line characters
  projectName = projectName.replace(/(\r\n|\n|\r)/gm,'')

  if (projectName == undefined || projectName.length == 0)
    return undefined

  exec('i3-msg -t get_workspaces', (error, stdout, stderr) ->
    wkList = JSON.parse(stdout)

    allOutputs = nf.getListOfOutputs(wkList)

    newWorkspaceNums = nf.getValidWorkspaceNums(wkList, allOutputs.length)

    commandToRun = ''

    wkNameProjectPart = '★' + projectName.toUpperCase() + '★'

    `
    for (var i = 1; i <= allOutputs.length; i++) {
      // 1. find a workspace which is on this output
      // 2. switch to it if it is already not focused
      // 3. create the new workspace

      var currentWKName = newWorkspaceNums[i-1] + ':' + wkNameProjectPart + i;

      var currentOutputWK = nf.getWorkspacesOnOutput(wkList, allOutputs[i-1])[0];

      if( (i != 1) || (currentOutputWK != nf.getFocusedWK(wkList)) ) {
        commandToRun = commandToRun + 'workspace ' + currentOutputWK + '; ';
      }
      
      commandToRun = commandToRun + 'workspace ' + currentWKName + '; ';
    }
    `

    commandToRun = 'i3-msg "' + commandToRun + '"'

    # exec('zenity --notification --text=' + JSON.stringify(commandToRun))
    # console.log(commandToRun)

    exec commandToRun
  )

if(process.argv[2]==undefined)
  exec("zenity --entry --title=I3 --text='Start a new project with the name:'", (error1, stdout1, stderr1) -> mainFunction(stdout1))
else
  mainFunction(process.argv[2])


