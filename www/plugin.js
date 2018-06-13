
var exec = require('cordova/exec');

var FLOW_WRAPPER_NATIVE = "FluigFlowWrapper";

var fluigSdk = {};

//flows

fluigSdk.flows = {};

fluigSdk.flows.login = function(success, error) {
  exec(success, error, FLOW_WRAPPER_NATIVE, "login", []);
};

fluigSdk.flows.eula = function(success, error, params) {
  exec(success, error, FLOW_WRAPPER_NATIVE, "eula", params);
};

//information

var INFORMATION_WRAPPER_NATIVE = "FluigInformationWrapper";

fluigSdk.information = {};

fluigSdk.information.getJwtToken = function(success, error) {
  exec(success, error, INFORMATION_WRAPPER_NATIVE, "getJwtToken", []);
};

fluigSdk.information.getLoggedUser = function(success, error) {
  exec(success, error, INFORMATION_WRAPPER_NATIVE, "getLoggedUser", []);
};

fluigSdk.information.getLoggedServer = function(success, error) {
  exec(success, error, INFORMATION_WRAPPER_NATIVE, "getLoggedServer", []);
};

fluigSdk.information.getSessions = function(success, error) {
  exec(success, error, INFORMATION_WRAPPER_NATIVE, "getSessions", []);
};

module.exports = fluigSdk;