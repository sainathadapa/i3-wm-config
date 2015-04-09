exec = require('child_process').exec
_ = require('lodash')
nf = require './necessaryFuncs.coffee'


mainFunc = (error1, stdout1, stderr1) ->
  exec('i3-msg -t get_workspaces',  (error, stdout, stderr) ->
    newProjectName = stdout1
    newProjectName = newProjectName.replace(/(\r\n|\n|\r)/gm,'').toUpperCase()

    wkList = JSON.parse(stdout)

    allWKNames = nf.getWKNames(wkList)

    currentWK = nf.getFocusedWK(wkList)

    currentProj = nf.getProjectFromWKName(currentWK)

    if currentProj == undefined
      return undefined

    currentProjWKs = nf.getWKNamesFromProj(wkList, currentProj)

    newProjWKs = currentProjWKs.map((x) ->
      x.replace("★" + currentProj + "★",  "★" + newProjectName + "★")
    )

    parCommand = _.map(currentProjWKs, (x,i) ->
      'rename workspace ' + currentProjWKs[i] + ' to ' + newProjWKs[i] + '; '
    )

    commandToRun = 'i3-msg "' + parCommand.join('') + '"'

    exec commandToRun
  )

if (process.argv[2] == undefined || process.argv[2] == '')
  exec("zenity --entry --title=I3 --text='rename current project to:'", mainFunc)
else
  mainFunc(undefined, process.argv[2], undefined)
