import UIKit
import fluigSDKCore
import fluigSDKFlows

@objc(FluigInformationWrapper)
public class FluigInformationWrapper: CDVPlugin {

    private var callbackId: String?
    
    @objc(getJwtToken:)
    public func getJwtToken(command: CDVInvokedUrlCommand) {
        
        self.callbackId = command.callbackId
        
        guard let tokens = FluigSDK.getCurrentUserTokens(),
            let jwtToken = tokens.JWTToken else {
                sendErrorResult(with: "Unable to retrieve the JWT token.")
                return
        }
        
        sendResult(with: ["jwtToken": jwtToken])
    }
    
    @objc(getLoggedUser:)
    public func getLoggedUser(command: CDVInvokedUrlCommand) {
        
        self.callbackId = command.callbackId
        
        guard let user = FluigSDK.currentUser else {
            sendErrorResult(with: "Unable to retrieve logged user information.")
            return
        }
        
        let json = user.toJSON()
        sendResult(with: json)
    }

    @objc(getLoggedServer:)
    public func getLoggedServer(command: CDVInvokedUrlCommand) {

        self.callbackId = command.callbackId

        sendErrorResult(with: "Unsupported method for login information plugin.")
    }

    @objc(getSessions:)
    public func getSessions(command: CDVInvokedUrlCommand) {

        self.callbackId = command.callbackId

        sendErrorResult(with: "Unsupported method for login information plugin.")
    }
    
    @objc
    private func sendResult(with dictionary: [String: Any]) {
        if dictionary.isEmpty {
            sendErrorResult(with: "Unable to convert retrieved information to JSON type.")
            return
        }
        
        let result = CDVPluginResult(status: CDVCommandStatus_OK,
                                     messageAs: dictionary)
        self.commandDelegate?.send(result, callbackId: self.callbackId)
    }
    
    @objc
    private func sendErrorResult(with message: String) {
        let result = CDVPluginResult(status: CDVCommandStatus_ERROR,
                                     messageAs: message)
        self.commandDelegate?.send(result, callbackId: self.callbackId)
    }
}