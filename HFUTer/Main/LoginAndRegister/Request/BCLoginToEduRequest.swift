//
//  BCLoginToEduRequest.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Alamofire

class BCLoginToEduRequest {
  static func login(user:EduUser,onLoginBlock:(() -> Void)?, onWrongPassWordBlock:(() -> Void)?, onFailedBlock:(() -> Void)?) {
    let url = getUrl(user.schoolYard, urlFor: "LOGIN")
    if user.schoolYard == "HF" {
      let params = [
        "IDToken0":"",
        "IDToken1":user.username,
        "IDToken2":user.password,
        "IDButton":"Submit",
        "goto":"",
        "encoded":"false",
        "inputCode":"",
        "gx_charset":"UTF-8"
      ]
      
      request(.POST, url, parameters: params, encoding: ParameterEncoding.URL, headers: nil)
        .response { request, response, data, error in
          if error != nil {
            onFailedBlock?()
            log.error("登录出错", param: ["error":"\(error)"])
            return
          }
          
          if let mystring = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String{
            if (mystring.rangeOfString("用户名或密码错误") != nil) {
              log.error("用户名或密码错误", param: params)
              onWrongPassWordBlock?()
            } else {
              _ = NSData(contentsOfURL: NSURL(string: "http://bkjw.hfut.edu.cn/StuIndex.asp")!)
              log.info("成功登入")
              onLoginBlock?()
            }
          } else {
            log.error("解码错误", param: nil)
            onFailedBlock?()
          }
      }
    } else {
      var password = user.password
      if password.characters.count > 12 {
        password = password[0..<12]
      }
      print(password)
      let params = [
        "UserStyle":"student",
        "user":user.username,
        "password":user.password
      ]
      request(.POST, url, parameters: params, encoding: ParameterEncoding.URL, headers: nil)
        .response { request, response, data, error in
          if error != nil {
            onFailedBlock?()
            log.error("登录出错", param: ["error":"\(error)"])
            return
          }
          if response?.URL == NSURL(string: "http://222.195.8.201/student/html/s_index.htm") {
            log.info("成功登入")
            onLoginBlock?()
          } else {
            log.error("用户名或密码错误", param: params)
            onWrongPassWordBlock?()
          }
      }
    }
  }
}