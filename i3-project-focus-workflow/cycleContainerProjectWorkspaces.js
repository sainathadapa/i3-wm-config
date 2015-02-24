'use strict';

var exec = require('child_process').exec,
_ = require('lodash'),
getI3WorkspacesInfo = require('./getI3WorkspacesInfo.js');

var mainFunc = function(currentWK, isCurrentWKOnProj, currentProj, currentProjWKs, currentWKPos, nextWKPos) {

	if(!isCurrentWKOnProj || nextWKPos==currentWKPos) {
		return undefined;
	}

	var commandToRun = 'i3-msg "move container to workspace ' + 
		currentProjWKs[nextWKPos] + '; workspace ' + currentProjWKs[nextWKPos] + '"; ';

	exec(commandToRun);
}; 

getI3WorkspacesInfo(mainFunc);
