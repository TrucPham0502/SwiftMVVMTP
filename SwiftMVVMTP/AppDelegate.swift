//
//  AppDelegate.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import UIKit
import Localize
import WebKit
enum Language : String {
    case vietnamese = "vi", english = "en", none
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var webView : WKWebView = {
        let v = WKWebView(frame: .zero)
        v.navigationDelegate = self
        return v
    }()
    var orientationLock = UIInterfaceOrientationMask.portrait
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        // add Module
       initModule()
        
        // language
        initLanguage()
        
        self.window?.rootViewController = UINavigationController(rootViewController: ViewController())
        self.window?.addSubview(webView)
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
    
    func playViewWithWebView(url: URL) {
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    //MARK: Language
    func changeLanguage(language: Language) {
        Localize.update(language: language.rawValue)
    }
    private func initLanguage(){
        Localize.update(provider: .json)
        Localize.update(fileName: "lang")
        Localize.update(defaultLanguage: Language.vietnamese.rawValue)
    }
    var currentLanguage : Language {
        return Language(rawValue: Localize.currentLanguage) ?? .none
    }
    
    //MARK: Module
    private func initModule(){
        Dependency.shared.build([TestModule(), MovieModule()])
    }

}

extension AppDelegate : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NotificationCenter.default.post(name: .playerLoading, object: true, userInfo: [:])
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NotificationCenter.default.post(name: .playerLoading, object: false, userInfo: [:])
    }
}
