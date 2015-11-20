//
//  EduUserModel.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation

class EduUser {
  var username = ""
  var password = ""
  var schoolYard = "HF"
  var isLogin = false
  var showWeekEnd = false
  var hasGetToken = false       /// 本次启动是否获取到了Token

  //详细信息
  var name = "获取失败，请重试"
  var gender = "获取失败，请重试"
  var academy = "获取失败，请重试"
  var major = "获取失败，请重试"
  var className = "获取失败，请重试"
}