//
//  AppDelegate.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import UIKit
import Localize
import WebKit
import FirebaseCore
import FirebaseMessaging
enum Language : String {
    case vietnamese = "vi", english = "en", none
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var webView : WKWebView = {
        let configuration = WKWebViewConfiguration()
        // Don't supress rendering content before everything is in memory.
        configuration.suppressesIncrementalRendering = false
        // Disallow inline HTML5 Video playback, as we need to be able to
        // hook into the AVPlayer to detect whether or not videos are being
        // played. HTML5 Video Playback makes that impossible.
        configuration.allowsInlineMediaPlayback = false
        // All audiovisual media will require a user gesture to begin playing.
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        let v = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
        v.isHidden = true
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
        
        self.window?.rootViewController = UINavigationController(rootViewController: SplashScreenViewController())
        self.window?.addSubview(webView)
        self.registerNotification(application)
        self.FirebaseInit(application)
        
        if let url = launchOptions?[.url] as? URL {
            executeDeepLink(with: url)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIWindowDidBecomeVisible), name: UIWindow.didBecomeVisibleNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIWindowBecomeHidden), name: UIWindow.didBecomeHiddenNotification, object: nil)
        return true
    }

    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == Constants.externalURLScheme {
            executeDeepLink(with: url)
        }
        return true
    }
    
    func registerNotification(_ application: UIApplication){
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
    }
    
    func FirebaseInit(_ application: UIApplication){
        guard let filePath = Bundle.main.path(forResource: Constants.googleServiceInfo, ofType: "plist"), let options = FirebaseOptions(contentsOfFile: filePath) else { return }
        FirebaseApp.configure(options: options)
        Messaging.messaging().delegate = self
    }
    
    func playViewWithWebView(url: URL) {
        NotificationCenter.default.post(name: .playerLoading, object: true, userInfo: [:])
        DispatchQueue.main.async {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
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
    
    
    @objc private func UIWindowDidBecomeVisible(){
        NotificationCenter.default.post(name: .playerLoading, object: false, userInfo: [:])
    }
    @objc private func UIWindowBecomeHidden(){
        NotificationCenter.default.post(name: .playerLoading, object: false, userInfo: [:])
        self.webView.stopLoading()
    }
}

extension AppDelegate : WKNavigationDelegate {
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        NotificationCenter.default.post(name: .playerLoading, object: true, userInfo: [:])
//    }
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        NotificationCenter.default.post(name: .playerLoading, object: false, userInfo: [:])
//        NotificationCenter.default.post(name: .playerLoading, object: webView.isLoading, userInfo: [:])
//    }
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        NotificationCenter.default.post(name: .playerLoading, object: webView.isLoading, userInfo: [:])
//    }
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        NotificationCenter.default.post(name: .playerLoading, object: false, userInfo: [:])
//    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let urlString = userInfo["deeplink"] as? String, let url = URL(string: urlString) {
            if  url.scheme == Constants.externalURLScheme {
                executeDeepLink(with: url)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    private func executeDeepLink(with url: URL) {
        // Create a recognizer with this app's custom deep link types
        let recognizer = DeepLinkRecognizer(deepLinkTypes: [
            OpenPageDeepLink.self, OpenAlertDeepLink.self])
        let _ = recognizer.deepLink(matching: url)
    }
    
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        Storage.set(data: fcmToken, key: StorageKey.NOTIFICATION_TOKEN.rawValue)
    }
    
}
