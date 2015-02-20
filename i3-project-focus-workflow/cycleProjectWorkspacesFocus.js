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

	var isCurrentWKOnProj = currentWK.indexOf('proj') > -1;

	if (!isCurrentWKOnProj) {
		return undefined;
	}

	var re = /^\d+:proj(.*)-\d+$/;

	var currentProj = currentWK.replace(re,'$1');

	var currentProjWKs = _.filter(allWKNames, function(x) {
		return (x.indexOf('proj' + currentProj) > -1);
	});

	currentProjWKs = _.sortBy(currentProjWKs, function(x) {return x;});

	var currentWKPos = _.findIndex(currentProjWKs, function(x) {
		return (x.indexOf(currentWK) > -1);
	});

	var nextWKPos = currentWKPos + 1;
	if (nextWKPos >= currentProjWKs.length) {
		nextWKPos = nextWKPos - currentProjWKs.length;
	}

	if (nextWKPos == currentWKPos) {
		return undefined;
	}

	var commandToRun = 'i3-msg "workspace ' + currentProjWKs[nextWKPos] + ';"';

	exec(commandToRun);
});
