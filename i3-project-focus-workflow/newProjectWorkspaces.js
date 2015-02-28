'use strict';

var exec = require('child_process').exec,
	_ = require('lodash');

var childProc = exec("zenity --entry --title=I3 --text='Start a new project with the name:'", function(error1, stdout1, stderr1) {
	var projectName = stdout1;

	projectName = projectName.replace(/(\r\n|\n|\r)/gm,'');

	if (projectName === undefined || projectName.length == 0) {
		return undefined;
	}

	exec('i3-msg -t get_workspaces', function (error, stdout, stderr) {
		var wkList = JSON.parse(stdout);

		var allOutputs = _.uniq(_.pluck(wkList, 'output'));

		var oneWKForOneOut = allOutputs.map(function(x) {
			var ans = _.filter(wkList, function(y) {
				return (y.output == x);
			});
			return ans[0].name;
		});

		var maxWk = _.max(_.pluck(wkList,'num'));

		var commandToRun = '';

		var wkPrefix = '★' + projectName.toUpperCase();

		var focusedWK = _.filter(wkList, function(x) {
			return (x.focused == true);
		});

		focusedWK = focusedWK[0].name;

		for (var i = 1; i <= allOutputs.length; i++) {
			// Steps:
			// 1. find a workspace which is on this output
			// 2. switch to it if it is already not focused
			// 3. create the new workspace

			var currentWKName = (maxWk + i) + ':' + wkPrefix + '★' + i;

			if ((i != 1) || (oneWKForOneOut[i - 1] != focusedWK)) {
				commandToRun = commandToRun + 'workspace ' + oneWKForOneOut[i - 1] + '; ';
			}

			commandToRun = commandToRun + 'workspace ' + currentWKName + '; ';
		}

		commandToRun = 'i3-msg "' + commandToRun + '"';

		// exec('zenity --notification --text=' + JSON.stringify(commandToRun));
		// console.log(commandToRun);

		exec(commandToRun);
	});
});
