
var exec = require('cordova/exec');

var FLOW_WRAPPER_NATIVE = "FluigFlowWrapper";
var FluigSdkFlows = {};

FluigSdkFlows.login = function(success, error) {
  exec(success, error, FLOW_WRAPPER_NATIVE, "login", []);
};

module.exports = FluigSdkFlows;
