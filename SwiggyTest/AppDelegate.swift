//
//  AppDelegate.swift
//  SwiggyTest
//
//  Created by Manas1 Mishra on 28/10/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = MovieListViewController()
        let navvc = UINavigationController(rootViewController: vc)
        
        self.window?.rootViewController = navvc
        //navvc.isNavigationBarHidden = true
        self.window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle



}

