//
//  AppDelegate.swift
//  FÜD
//
//  Created by Nathan  on 3/21/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let userDefaults = UserDefaults.standard
        
        if userDefaults.object(forKey: "slider_value") == nil {
            userDefaults.set(16093.4, forKey: "slider_value")
        }
        return true
    }


}

