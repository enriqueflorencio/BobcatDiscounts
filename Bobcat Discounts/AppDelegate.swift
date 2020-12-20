//
//  AppDelegate.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 11/30/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var standard: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {} else {
            /// Create the storyboard programmatically
            window = UIWindow(frame: UIScreen.main.bounds)
            /// Create the navigation controller and assign the root view controller to the selection screen
            let navigationController = UINavigationController(rootViewController: MainTabBarViewController())
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            
            
        }
        return true
        
    }


}

