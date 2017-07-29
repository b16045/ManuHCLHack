//
//  AppDelegate.swift
//  ManuHCLHack
//
//  Created by Arpit on 22/07/17.
//  Copyright © 2017 Sayan. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        locationManager.delegate = self
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert,.sound]) {(granted, error) in }

        return true
    }

//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }

}

extension AppDelegate: CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if (region.isEqual(darkBlue)){
//            var text : String = "Welcome to Manchester United Museum Region1"
//            Notifications.display(text)
//        }
//        if (region.isEqual(skyBlue)){
//            var text : String = "Welcome to Manchester United Museum Region2"
//            Notifications.display(text)
//        }
//        if (region.isEqual(green)){
//            var text : String = "Welcome to Manchester United Museum Region3"
//            Notifications.display(text)
//        }
//        enteredRegion = true
//        
//    
//    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion){
        guard region is CLBeaconRegion else {return}
        
        let content = UNMutableNotificationContent()
        content.title = "Hello User"
        content.body = "Are you sure you want to exit?"
        //content.sound = .default()
        
        let request = UNNotificationRequest(identifier: "ForgetMeNot", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}


