//
//  AppDelegate.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import UIKit
import Localize

enum Language : String {
    case vietnamese = "vi", english = "en", none
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        // add Module
       initModule()
        
        // language
        initLanguage()
        
        self.window?.rootViewController = UINavigationController(rootViewController: MovieHomeViewController())
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
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

