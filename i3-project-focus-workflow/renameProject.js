'use strict';

var exec = require('child_process').exec,
	_ = require('lodash');


var mainFunc = function(error1, stdout1, stderr1) {
	exec('i3-msg -t get_workspaces', function (error, stdout, stderr) {
		var newProjectName = stdout1;
		newProjectName = newProjectName.replace(/(\r\n|\n|\r)/gm,'').toUpperCase();


		var wkList = JSON.parse(stdout);

		var allWKNames = _.pluck(wkList, 'name');

		var currentWK = _.filter(wkList, function(x) {
			return x.focused == true;
		});
		currentWK = currentWK[0].name;

		var isCurrentWKOnProj = currentWK.indexOf('proj') > -1;

		if (!isCurrentWKOnProj) {
			return undefined;
		}

		var re = /^\d+:proj(.*)-\d+$/;

		var currentProj = currentWK.replace(re,'$1');

		var currentProjWKs = _.filter(allWKNames, function(x) {
			return (x.indexOf('proj' + currentProj) > -1);
		});

		var newProjWKs = currentProjWKs.map(function(x) {
			return x.replace(currentProj, newProjectName);
		});

		var commandToRun = '';
		for (var i = 0; i < currentProjWKs.length; i++) {
			commandToRun = commandToRun + 'rename workspace ' +
				currentProjWKs[i] + ' to ' + newProjWKs[i] + '; ';
		}

		commandToRun = 'i3-msg "' + commandToRun + '"';

		exec(commandToRun);
	});
};

if (process.argv[2] == undefined || process.argv[2] == '') {
	exec("zenity --entry --title=I3 --text='rename current project to:'", mainFunc);
} else {
	mainFunc(undefined, process.argv[2], undefined);
}
