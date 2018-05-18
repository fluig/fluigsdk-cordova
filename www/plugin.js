
var exec = require('cordova/exec');

var FLOW_WRAPPER_NATIVE = "FluigFlowWrapper";

var FluigSdkFlows = {};

FluigSdkFlows.login = function(success, error) {
  exec(success, error, FLOW_WRAPPER_NATIVE, "login", []);
};

module.exports = FluigSdkFlows;

var LOGIN_INFORMATION_WRAPPER_NATIVE = "FluigInformationWrapper";

var FluigSdkInformation = {};

FluigSdkInformation.getJwtToken = function(success, error) {
  exec(success, error, LOGIN_INFORMATION_WRAPPER_NATIVE, "getJwtToken", []);
};

FluigSdkInformation.getLoggedUser = function(success, error) {
  exec(success, error, LOGIN_INFORMATION_WRAPPER_NATIVE, "getLoggedUser", []);
};

FluigSdkInformation.getLoggedServer = function(success, error) {
  exec(success, error, LOGIN_INFORMATION_WRAPPER_NATIVE, "getLoggedServer", []);
};

FluigSdkInformation.getSessions = function(success, error) {
  exec(success, error, LOGIN_INFORMATION_WRAPPER_NATIVE, "getSessions", []);
};

module.exports = FluigSdkInformation;