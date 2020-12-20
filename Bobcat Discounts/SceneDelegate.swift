//
//  SceneDelegate.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 11/30/20.
//

import UIKit
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let defaults = UserDefaults.standard
        let didOnboard = defaults.bool(forKey: "isOnboarded")
        if(didOnboard) {
            window.rootViewController = UINavigationController(rootViewController: MainTabBarViewController())
        } else {
            window.rootViewController = OnboardingViewController()
        }
        window.makeKeyAndVisible()
        
        self.window = window
        
        AppDelegate.standard.window = window
        
    }



}

