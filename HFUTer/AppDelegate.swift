//
//  AppDelegate.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

import BRYXBanner

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var app:UIApplication!
  var rootVC: RootViewController!

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    //初始化第三方SDK
    Fabric.with([Answers.self,Crashlytics.self])
    APService.registerForRemoteNotificationTypes(2, categories: nil)
    APService.setupWithOption(launchOptions)
    
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    app    = application
    rootVC = RootViewController()

    //初始化数据环境
    DataEnv.eduUser = PlistManager.readEduUser()
    DataEnv.loginComUser()
    DataEnv.calculateCurrentWeek()
    PlistManager.readTintColor()

    window?.backgroundColor = UIColor.whiteColor()
    let rootViewController = rootVC
    let rootNavController = UINavigationController(rootViewController:rootViewController)
    rootNavController.navigationBarHidden = true
    window!.rootViewController = rootNavController
    window!.makeKeyAndVisible()
    window!.tintColor = Color.primaryTintColor
    return true
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    APService.registerDeviceToken(deviceToken)
    if DataEnv.eduUser.isLogin {
      APService.setTags(["push"], alias: DataEnv.eduUser.username, callbackSelector: nil, object: nil)
    } else {
      APService.setTags([""], alias: "未登录", callbackSelector: nil, object: nil)
    }
    
    print(deviceToken)
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    APService.handleRemoteNotification(userInfo)
    print(userInfo)
    if let aps = userInfo["aps"] {
      let banner = Banner(title:nil, subtitle: aps["alert"] as? String, image: nil, backgroundColor: UIColor(red:42.8/255.0, green:162.6/255.0, blue:35.3/255.0, alpha:1.0))
      banner.dismissesOnTap = true
      banner.show(duration: 3.0)
    }
  }
}

