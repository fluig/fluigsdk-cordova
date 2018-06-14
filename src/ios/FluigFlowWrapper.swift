import UIKit
import fluigSDKFlows
import fluigSDKUi

@objc(FluigFlowWrapper)
public class FluigFlowWrapper: CDVPlugin {

    private var callbackId: String?

    @objc(login:)
    public func login(command: CDVInvokedUrlCommand) {
        guard UIApplication.shared.keyWindow != nil else {
            self.commandDelegate?.send(
                CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "UIWindow not found."),
                                callbackId: ""
                )
            return
        }

        self.callbackId = command.callbackId
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loginDidSucceed),
            name: Notification.Name.fluigSdkDidLogin,
            object: nil
        )

        var configuration = LoginFlowConfiguration()
        if command.arguments.count > 0, let json = command.argument(at: 0) as? [String: Any] {
            enum JSONKeys: String {
                case logoImage
                case bgImage
                case bgVideo
                case bgColor
                case bgColorEnd
                case emailRequestPageTitle
                case emailRequestPageTips
                case pwdRequestPageTitle
            }

            configuration.emailRequestPageTitle = json[JSONKeys.emailRequestPageTitle.rawValue] as? String
            configuration.emailRequestPageTips = json[JSONKeys.emailRequestPageTips.rawValue] as? [String] ?? []
            configuration.passwordRequestPageTitle = json[JSONKeys.pwdRequestPageTitle.rawValue] as? String

            if let name = json[JSONKeys.logoImage.rawValue] as? String {
                configuration.logoImage = UIImage(named: name)
            }

            if let name = json[JSONKeys.bgVideo.rawValue] as? String,
                let url = Bundle.main.url(forResource: String(name.split(separator: ".")[0]),
                                          withExtension: String(name.split(separator: ".")[1])) {
                configuration.background = .video(url)
            }

            if let name = json[JSONKeys.bgImage.rawValue] as? String,
                let image = UIImage(named: name) {
                configuration.background = .image(image)
            }

            if let bgColor = json[JSONKeys.bgColor.rawValue] as? String ,
                let bgColor2 = json[JSONKeys.bgColorEnd.rawValue] as? String {
                configuration.background = .gradient((UIColor(hexString: bgColor), UIColor(hexString: bgColor2)))
            }
        }

        LoginFlow(configuration: configuration).startAsRoot(window: UIApplication.shared.keyWindow!)
    }

    @objc
    private func loginDidSucceed() {
        guard let callbackId = self.callbackId else {
            self.commandDelegate?.send(CDVPluginResult(status: CDVCommandStatus_ERROR,
                                                       messageAs: "Callback 'success' could not be called."),
                                       callbackId: "")
            return
        }

        NotificationCenter.default.removeObserver(self, 
                                                  name: Notification.Name.fluigSdkDidLogin,
                                                  object: nil)

        self.commandDelegate?.send(CDVPluginResult(status: CDVCommandStatus_OK),
                                   callbackId: callbackId)
    }

    @objc(eula:)
    public func eula(command: CDVInvokedUrlCommand) {
        guard UIApplication.shared.keyWindow != nil else {
            self.commandDelegate?.send(
                CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "UIWindow not found."),
                callbackId: ""
            )
            return
        }

        self.callbackId = command.callbackId
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didAcceptEULA),
            name: Notification.Name.fluigSdkDidAcceptEula,
            object: nil
        )

        var termsConfiguration = EulaFlowConfiguration()
        if command.arguments.count > 0, let json = command.argument(at: 0) as? [String: String] {
            enum JSONKeys: String {
                case appName
                case username
                case bgColorHex
                case bgColorEndHex
                case logoImageName
                case termsFileName
            }

            termsConfiguration.appName = json[JSONKeys.appName.rawValue]
            termsConfiguration.username = json[JSONKeys.username.rawValue]
            termsConfiguration.backgroundColor = UIColor(hexString: json[JSONKeys.bgColorHex.rawValue] ?? "#F15823")
            termsConfiguration.backgroundColor = UIColor(hexString: json[JSONKeys.bgColorEndHex.rawValue] ?? "#ED165A")

            if let name = json[JSONKeys.logoImageName.rawValue] {
                termsConfiguration.logoImage = UIImage(named: name)
            }

            if let name = json[JSONKeys.termsFileName.rawValue],
                let url = Bundle.main.url(forResource: String(name.split(separator: ".")[0]),
                                          withExtension: String(name.split(separator: ".")[1])) {
                termsConfiguration.termsURL = url
            }
        }

        EulaFlow(configuration: termsConfiguration)
            .start(from: viewController)
    }

    @objc
    private func didAcceptEULA() {
        NotificationCenter.default.removeObserver(self, 
                                                  name: Notification.Name.fluigSdkDidAcceptEula,
                                                  object: nil)

        self.commandDelegate?.send(CDVPluginResult(status: CDVCommandStatus_OK),
                                   callbackId: callbackId)
    }
}
