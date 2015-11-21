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


let colorAlphaComponent:CGFloat  = 0.7
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Managers


let Color = ColorManager.sharedManager()
let Hud   = EEHudView.sharedManager()
let DataEnv = DataEnvironment.sharedManager()

let NotifCenter =  NSNotificationCenter.defaultCenter()

typealias log = BClog

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//UI

let ScreenWidth                 =       UIScreen.mainScreen().bounds.size.width
let ScreenHeight                =       UIScreen.mainScreen().bounds.size.height



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Notification


let BCUserLoginNotification             = "HDUserLoginNotification"
let BCChangeTintColorNotification       = "BCChangeTintColorNotification"


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//AVClassNames


let AVGoodListClassName                 = "good_list"
let AVGoodOrderListClaasName            = "order_list"
let AVClientListClassName               = "client_list"