'use strict';

var exec = require('child_process').exec,
	_ = require('lodash');

var projectName = process.argv[2];

exec('i3-msg -t get_workspaces', function (error, stdout, stderr) {
	var wkList = JSON.parse(stdout);

	var allOutputs = _.uniq(_.pluck(wkList, 'output'));

	var maxWk = _.max(_.pluck(wkList,'num'));

	var commandToRun = '';

	var wkPrefix = 'proj' + projectName.toUpperCase();

	for (var i = 1; i <= allOutputs.length; i++) {
		var oneWKonCurrentOutput = _.filter(wkList, function(x) {
			return(x.output == allOutputs[i - 1]);
		});
		oneWKonCurrentOutput = oneWKonCurrentOutput[0].name;

		var currentWKName = (maxWk + i) + ':' + wkPrefix + '-' + i;

		commandToRun = commandToRun + 'workspace ' + oneWKonCurrentOutput + '; ';
		commandToRun = commandToRun + 'workspace ' + currentWKName + '; ';
		commandToRun = commandToRun + 'move workspace ' + currentWKName + ' to output ' + allOutputs[i - 1] + '; ';
	}

	commandToRun = 'i3-msg "' + commandToRun + '"';

	console.log(commandToRun);

	exec(commandToRun);
});
