//
//  AppDelegate.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/23.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import DKImagePickerController
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate{
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    var productArray = [Product]()
    var cellOfNum:Int!
    var opposerid: String!
    var productid: String!
    var photoCount: Int!
    var sectionID: Int!
    var posX: CGFloat!
    var posY: CGFloat!
    var width: CGFloat!
    var height: CGFloat!
    var posArray = [CGFloat]()
    var db: Firestore!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        // UNUserNotificationCenterDelegateの設定
        UNUserNotificationCenter.current().delegate = self
        // FCMのMessagingDelegateの設定
        Messaging.messaging().delegate = self
        
        // リモートプッシュの設定
        application.registerForRemoteNotifications()
        // Firebase初期設定
        FirebaseApp.configure()
        db = Firestore.firestore()
        // アプリ起動時にFCMのトークンを取得し、表示する
        if let token = Messaging.messaging().fcmToken{
            print(String(describing: type(of: token)))
            print("FCM token: \(token)")
            if let uid = Auth.auth().currentUser?.uid{
                db.collection("users").document(uid).updateData(["fcmToken" : token])
            }
        }

        UINavigationBar.appearance().barTintColor = UIColor.orange
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:  UIColor.white]
        var viewControllers: [UIViewController] = []
        
        // 1ページ目になるViewController
        let firstSB = UIStoryboard(name: "A", bundle: nil)
        let firstVC = firstSB.instantiateInitialViewController()! as UIViewController
        firstVC.tabBarItem = UITabBarItem(title: "取引", image: UIImage(named:"trade.png"), tag: 1)
        viewControllers.append(firstVC)
        
        // 2ページ目になるViewController
        let secondSB = UIStoryboard(name: "C", bundle: nil)
        let secondVC = secondSB.instantiateInitialViewController()! as UIViewController
        secondVC.tabBarItem = UITabBarItem(title: "チャット", image: UIImage(named:"chat.png"), tag: 2)
        viewControllers.append(secondVC)
        
        // 3ページ目になるViewController
        let thirdSB = UIStoryboard(name: "D", bundle: nil)
        let thirdVC = thirdSB.instantiateInitialViewController()! as UIViewController
        thirdVC.tabBarItem = UITabBarItem(title: "イベント", image: UIImage(named:"event.png"), tag: 3)
        viewControllers.append(thirdVC)
        
        // 4ページ目になるViewController
        let fourthSB = UIStoryboard(name: "E", bundle: nil)
        let fourthVC = fourthSB.instantiateInitialViewController()! as UIViewController
        fourthVC.tabBarItem = UITabBarItem(title: "授業評価", image: UIImage(named:"curriculum.png"), tag: 4)
        viewControllers.append(fourthVC)
        
        // 5ページ目になるViewController
        let fifthSB = UIStoryboard(name: "B", bundle: nil)
        let fifthVC = fifthSB.instantiateInitialViewController()! as UIViewController
        fifthVC.tabBarItem = UITabBarItem(title: "その他", image: UIImage(named:"option.png"), tag: 5)
        viewControllers.append(fifthVC)
        
        
        // ViewControllerをセット
        let tabBarController = UITabBarController()
        posX = tabBarController.tabBar.frame.origin.x
        posY = tabBarController.tabBar.frame.origin.y
        width = tabBarController.tabBar.frame.width
        height = tabBarController.tabBar.frame.height
        posArray = [posX,posY,width,height]
        
        tabBarController.tabBar.unselectedItemTintColor = UIColor.orange
        tabBarController.tabBar.tintColor = UIColor.red
        //        tabBarController.tabBar.backgroundColor = UIColor.black
        tabBarController.setViewControllers(viewControllers, animated: false)
        
        // rootViewControllerをUITabBarControllerにする
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("フロントでプッシュ通知受け取ったよ")
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        
    }
    
    
}







