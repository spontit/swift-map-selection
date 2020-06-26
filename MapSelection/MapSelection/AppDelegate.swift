//
//  AppDelegate.swift
//  MapSelection
//
//  Created by Zhang Qiuhao on 6/25/20.
//  Copyright © 2020 Zhang Qiuhao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "viewController") as! ViewController
        self.window?.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    
}

