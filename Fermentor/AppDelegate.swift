//
//  AppDelegate.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Log.verbose("App Launching 👨🏻‍🚀👩🏻‍🚀🚀")
        
        let navigationController = self.window?.rootViewController as! UINavigationController
        
        let coordinator = Coordinator(navigationController: navigationController,
                                      workspace: Kitchen())
        
        coordinator.displayPickleList()

        return true
    }

}

