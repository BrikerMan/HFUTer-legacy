//
//  Macros.swift
//  Hande
//
//  Created by Eliyar Eziz on 15/11/17.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

let communityServer = "http://hfut.cn-hangzhou.aliapp.com/"

let NetErrorWarning = "网络错误，请稍候再试"



let GB2312Encoding = CFStringConvertEncodingToNSStringEncoding(0x0632)
let colorAlphaComponent:CGFloat  = 0.8
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Managers

let isFisrtLaunchOfThisVersion = isAppFirstLaunchedForVersion("1.60001")

let Color = ColorManager.sharedManager()
let Hud   = EEHudView.sharedManager()
let DataEnv = DataEnvironment.sharedManager()

let NotifCenter =  NSNotificationCenter.defaultCenter()

typealias log = BClog


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


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//AVClassNames


let AVGoodListClassName                 = "good_list"
let AVGoodOrderListClaasName            = "order_list"
let AVClientListClassName               = "client_list"




///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
let XUEQIDAIMA = "027"