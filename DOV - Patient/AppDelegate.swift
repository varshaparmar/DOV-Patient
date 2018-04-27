//
//  AppDelegate.swift
//  DOV - Patient
//
//  Created by Admin on 4/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
//import Reachability
//import ReachabilitySwift
import UserNotifications
import IQKeyboardManagerSwift
import Reachability
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isNetworkBecomeAvailableFirstTime = false
    var reachability: Reachability?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Start reachability without a hostname intially
        setupReachability(nil, useClosures: false)
        startNotifier()
        
        //** Configure |IQKeyboardManager|
        IQKeyboardManager.sharedManager().enable = true;
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        
     
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
    }
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        print(aps)

    }

    // MARK: MBProgressHUD Methods
    //****************************************************
    
    func showHUD(_ hudTitle : String, onView: UIView) {
        
        let hud: MBProgressHUD = MBProgressHUD.showAdded(to: onView, animated: true)
        //hud.mode = MBProgressHUDMode.AnnularDeterminate
        hud.bezelView.color = colorClear
        hud.contentColor = UIColor.white
        
        //hud.activityIndicatorColor = colorWhite
        
        hud.label.textColor = colorWhite
        hud.bezelView.color = UIColor.lightGray
        hud.label.font = UIFont(name: AppFontBook, size: 17)
        
        if Util.isValidString(hudTitle) {
            hud.label.text = hudTitle
        }
        else {
            hud.label.text = "Loading..."
        }
    }
    
    func hideHUD(_ fromView: UIView) {
        MBProgressHUD.hide(for: fromView, animated: true)
    }
    
    //****************************************************
    // MARK: - Network Reachability Methods
    //****************************************************
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        self.reachability = reachability
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        }
        catch {
            return
        }
    }
    
    func stopNotifier() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: nil)
        reachability = nil
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        isNetworkAvailable = reachability.isReachable
        
        if reachability.isReachable {
            
            if UserDefaults.standard.bool(forKey: Key_UD_IsUserLoggedIn) && isNetworkAvailable && !isNetworkBecomeAvailableFirstTime {
                
                isNetworkBecomeAvailableFirstTime = true
                
                //** Post notification for |NetworkBecomeAvailableFirstTime|
                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationNetworkBecomeAvailableFirstTime), object: self, userInfo:nil)
            }
        }
        else {
            if isNetworkBecomeAvailableFirstTime == false {
                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationNetworkBecomeAvailableFirstTime), object: self, userInfo:nil)
            }
        }
    }
    
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        log.info("Device Token String:\(token)")
        
        //** Remove special character and get valid device token string
        let characterSet: CharacterSet = CharacterSet( charactersIn: "<>" )
        
        let deviceTokenString: String = (token as NSString ) .trimmingCharacters(in: characterSet) .replacingOccurrences(of: " ", with: "" ) as String
        
        print(deviceTokenString)
      //  deviceToken = deviceTokenString
    //    UserDefaults.standard.set(Util.getValidString(deviceToken), forKey: kAPI_IOSId)
    }
    
}

