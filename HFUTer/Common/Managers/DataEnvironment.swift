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
  var comUser = ComUser()
  var currentWeek = 1 {
    didSet{
      if currentWeek <= 1 {
        currentWeek = 1
      }
    }
  }

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
      BCLoginToEduRequest.login(DataEnv.eduUser,
        onLoginBlock: { () -> Void in
          completion(sccess: true, error: nil)
        }, onWrongPassWordBlock: { () -> Void in
          completion(sccess: false, error: "登录过期，请重新登录")
        }) { () -> Void in
          completion(sccess: false, error: "网络异常，请稍后再试")
      }
    }
  }

  func saveCookie(cookie:String?) {
    if let cookie = cookie {
      if cookie != "" {
        comUser.cookie = cookie
        comUser.isLogin = true
      }
    } else {
    }
  }


  func loginComUser() {
    comUser = readComUser()
    if comUser.isLogin {
      BCCommunityUserLoginRequest.login(comUser.username, password: comUser.password,
        onSuccessBlock: { (response) -> () in
          self.comUser.isLogin = true
          if let data = response["data"] as? NSDictionary{
            if let link = data["image"] as? String {
              self.comUser.avatar = link
            }
          }
          self.saveComUser(self.comUser)
        }, onFailedBlock: { (reason) -> () in
          self.comUser.isLogin = false
        }, onNetErrorBlock: { () -> () in
          self.comUser.isLogin = false
      })
    }
  }

  func readComUser() -> ComUser{
    return  PlistManager.readComUser()
  }


  func saveComUser(user:ComUser) {
    PlistManager.saveComUser(user)
    self.comUser.username = user.username
    self.comUser.password = user.password
    self.comUser.avatar = user.avatar
    self.comUser.isLogin = true

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