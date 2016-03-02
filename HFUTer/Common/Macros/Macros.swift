//
//  Macros.swift
//  Hande
//
//  Created by Eliyar Eziz on 15/11/17.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

let communityServer = "http://hfut.cn-hangzhou.aliapp.com/"
let notificationJsonFileURL = "https://coding.net/u/eliyar917/p/HFUTer-Settings/git/raw/master/info_for_iOS.json"

let NetErrorWarning = "网络错误，请稍候再试"

let GB2312Encoding = CFStringConvertEncodingToNSStringEncoding(0x0632)
let colorAlphaComponent:CGFloat  = 0.9
//////////////////////////////////////////////////////////////////////////  /////////////////////////////////////////////
//Managers

let isFisrtLaunchOfThisVersion = isAppFirstLaunchedForVersion("2.0")

let Color = ColorManager.sharedManager()
let Hud   = EEHudView.sharedManager()
let DataEnv = DataEnvironment.sharedManager()

let NotifCenter =  NSNotificationCenter.defaultCenter()

typealias log = EELog


let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let RootVC      = appDelegate.rootVC

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//UI

let ScreenWidth                 =       UIScreen.mainScreen().bounds.size.width
let ScreenHeight                =       UIScreen.mainScreen().bounds.size.height



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Notification


let BCUserLoginNotification             = "HDUserLoginNotification"
let BCUserLogOutNotification            = "BCUserLogOutNotification"
let BCChangeTintColorNotification       = "BCChangeTintColorNotification"
let EEUserChangedAvatarNotification     = "EEUserChangedAvatarNotification"

let EEUserChangedWeekEndSchdeuleSettingNotification  = "EEUserChangedWeekEndSchdeuleSettingNotification "

let EEHasReceiveNotifNotification			= "EEHasReceiveNotifNotification"
let EEHasReceiveUpdateNotification			= "EEHasReceiveUpdateNotification"
let EEHasReceiveLoginWarningNotification		= "EEHasReceiveLoginWarningNotification"
let EEHasReceiveOtherNotification			= "EEHasReceiveOtherNotification"


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//AVClassNames


let AVGoodListClassName                 = "good_list"
let AVGoodOrderListClaasName            = "order_list"
let AVClientListClassName               = "client_list"




///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
let XUEQIDAIMA = "028"
let HFSemesterStartTime = 1456070400
let XCSemesterStartTime = 1456070400