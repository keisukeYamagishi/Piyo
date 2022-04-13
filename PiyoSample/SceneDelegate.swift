//
//  SceneDelegate.swift
//  PiyoSample
//
//  Created by Shichimitoucarashi on 2020/05/25.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        let scheme = "piyooauth-rbniuwhcqa9ynl5etljuttqxe://"
        if url.absoluteString.hasPrefix(scheme) {
            let splitPrefix: String = url.absoluteString.replacingOccurrences(of: "\(scheme)?", with: "")
            print("Split prefix: \(splitPrefix)")
            TwitterApi.access(token: splitPrefix) {
                TwitterApi.user { user in
                    do {
                        let option = JSONSerialization.ReadingOptions.allowFragments
                        guard let userInfo = try JSONSerialization.jsonObject(with: user,
                                                                              options: option) as? [String: Any] else { return }
                        print(userInfo)
                        TwitterApi.tweetWithMedia(tweet: "Hello,,,,,,,,")
                    } catch {
                        print("Exception: \(error)")
                    }
                }
            }
        }
    }
}
