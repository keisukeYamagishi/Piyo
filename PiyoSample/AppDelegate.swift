//
//  AppDelegate.swift
//  PiyoSample
//
//  Created by Shichimitoucarashi on 2020/05/25.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import UIKit
import Piyo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        TwitterKey.shared.api.key = "RbNIuWhcQA9YNL5etljuTtQXe"
        TwitterKey.shared.api.secret = "Ms86swzRP3t0NElcx8yxPr9dlpJl0jm4I0Dn4L3ofHuRJ4W0bp"        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

