
var exec = require('cordova/exec');

var NATIVE_CLASS_NAME = "FluigLoginWrapper";
var FluigSdkFlows = {};

FluigSdkFlows.login = function(success, error) {
  exec(success, error, NATIVE_CLASS_NAME, "start", []);
};

module.exports = FluigSdkFlows;
