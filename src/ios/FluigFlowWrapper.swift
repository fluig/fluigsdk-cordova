import UIKit
import fluigSDKFlows

@objc(FluigFlowWrapper)
public class FluigFlowWrapper: CDVPlugin {

    private var callbackId: String?

    @objc(login:)
    public func login(command: CDVInvokedUrlCommand) {

        guard UIApplication.shared.keyWindow != nil else {
            self.commandDelegate?.send(CDVPluginResult(status: CDVCommandStatus_ERROR,
                                                       messageAs: "UIWindow not found."),
                                       callbackId: "")
            return
        }

        self.callbackId = command.callbackId

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginDidSucceed),
                                               name: Notification.Name.fluigSdkDidLogin,
                                               object: nil)

        LoginFlow(configuration: LoginFlowConfiguration())
            .startAsRoot(window: UIApplication.shared.keyWindow!)
    }

    @objc
    private func loginDidSucceed() {
        guard let callbackId = self.callbackId else {
            self.commandDelegate?.send(CDVPluginResult(status: CDVCommandStatus_ERROR,
                                                       messageAs: "Callback 'success' could not be called."),
                                       callbackId: "")
            return
        }

        self.commandDelegate?.send(CDVPluginResult(status: CDVCommandStatus_OK),
                                   callbackId: callbackId)
    }
}