'use strict';

var exec = require('child_process').exec,
	_ = require('lodash');

exec('i3-msg -t get_workspaces', function (error, stdout, stderr) {
	var wkList = JSON.parse(stdout);

	var allWKNames = _.pluck(wkList, 'name');

	var currentWK = _.filter(wkList, function(x) {
		return x.focused == true;
	});
	currentWK = currentWK[0].name;

	var isCurrentWKOnProj = currentWK.indexOf('★') > -1;

	if (!isCurrentWKOnProj) {
		return undefined;
	}

	var re = /^\d+:★(.*)★\d+$/;

	var currentProj = currentWK.replace(re,'$1');

	var currentProjWKs = _.filter(wkList, function(x) {
		return (x.name.indexOf('★' + currentProj) > -1);
	});

	currentProjWKs = _.sortBy(currentProjWKs, function(x) {return x.name;});

	var currentProjWKNames = _.pluck(currentProjWKs, 'name');
	var currentProjWKOutputs = _.pluck(currentProjWKs, 'output');

	var newOutputPos = new Array(currentProjWKOutputs.length)
	.join().split(',')
	.map(function(item, index){ return index;});

	newOutputPos = newOutputPos.map(function(x) {
		x = x + 1;
		if (x >= currentProjWKOutputs.length) {
			x = x - currentProjWKOutputs.length;
		}
		return x;
	});

	var newOutputs = newOutputPos.map(function(x) {
		return currentProjWKOutputs[x];
	});


	var commandToRun = '';
	for (var i = 0; i < newOutputs.length; i++) {
		if ((i != 0) || (currentProjWKNames[i] != currentWK)) {
			commandToRun = commandToRun + 'workspace ' + currentProjWKNames[i] + '; ';
		}

		commandToRun = commandToRun + 'move workspace to output ' + newOutputs[i] + '; ';
	}

	commandToRun = 'i3-msg "' + commandToRun + '"';

	// console.log(commandToRun);
	exec(commandToRun);
});
