'use strict';

var exec = require('child_process').exec,
_ = require('lodash');

exec('i3-msg -t get_workspaces', function (error, stdout, stderr) {
	var wkList = JSON.parse(stdout);

	var allOutputs = _.uniq(_.pluck(wkList, 'output'));

	var allWKNames = _.pluck(wkList, 'name');

	var re = /^\d+:★(.*)★\d+$/;

	var allProjs = _.uniq(
		_.map(
			_.filter(allWKNames, function(x) {
		return x.indexOf("★") > -1;
	}),function(x) {
		return x.replace(re, '$1');
	}));

	allProjs = _.sortBy(allProjs, function(x) {return x;}); 
	console.log(allProjs);

	if(allProjs.length==0) {
		return undefined;
	}

	var currentWK = _.filter(wkList, function(x) {
		return x.focused == true;
	});

	currentWK = currentWK[0].name;

	var isCurrentWKOnProj = currentWK.indexOf("★") > -1;

	var nextProj;

	if(isCurrentWKOnProj) {
		var currentProj = currentWK.replace(re,'$1');
		var currentProjPos = _.findIndex(allProjs, function(x) {
			return (x.indexOf(currentProj) > -1);
		});
		var nextProjPos = currentProjPos + 1;
		if(nextProjPos >= allProjs.length) {
			nextProjPos = nextProjPos - allProjs.length;
		}
		nextProj = allProjs[nextProjPos];
	} else {
		nextProj = allProjs[0];
	}

	var wksToFocus = _.filter(allWKNames, function(x) {
		return (x.indexOf('★' + nextProj) > -1);
	});

	var currentWKObj;
	wksToFocus = _.filter(wksToFocus, function(x) {
		currentWKObj = _.filter(wkList, function(y) {
			return (y.name == x);
		});
		return (currentWKObj[0].visible == false);
	});

	if(wksToFocus.length > 0) {
		var commandToRun = '';
		for (var i = 0; i < wksToFocus.length; i++) {
			commandToRun = commandToRun + 'workspace ' + wksToFocus[i] + '; '; 
		}
		commandToRun = 'i3-msg "' + commandToRun + '"';
	}
	// console.log(commandToRun);

	exec(commandToRun);
});
