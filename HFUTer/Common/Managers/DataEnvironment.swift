//
//  DataEnvironment.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
private let _SingletonASharedInstance = DataEnvironment()

class DataEnvironment {

  var eduUser:EduUser!
  var currentWeek = 0

  //单例
  class func sharedManager() -> DataEnvironment {
    return _SingletonASharedInstance
  }

  func saveEduUser(user:EduUser) {
    self.eduUser = user
    self.eduUser.isLogin = true
    PlistManager.saveEduUser(self.eduUser)
  }

  func getEduUserToken(completion:((sccess:Bool,error:String?)->())) {
    if self.eduUser.hasGetToken {
      completion(sccess: true, error: nil)
    } else {
//      BCLoginToEduRequest.login(DataEnv.eduUser,
//        onLoginBlock: { () -> Void in
//          self.eduUser.hasGetToken = true
//          completion(sccess: true, error: nil)
//        }, onWrongPassWordBlock: { () -> Void in
//          completion(sccess: false, error: "登录过期，请重新登录")
//        }) { () -> Void in
//          completion(sccess: false, error: "网络异常，请稍后再试")
//      }
    }
  }


  func calculateCurrentWeek() {
    var from = NSTimeInterval()
    if self.eduUser.schoolYard == "HF" {
      from = NSTimeInterval(1442160000)
    } else {
      from = NSTimeInterval(1440950400)
    }

    let now = (NSDate().timeIntervalSince1970)
    self.currentWeek = Int((now - from)/(7 * 24 * 3600)) + 1
  }

}