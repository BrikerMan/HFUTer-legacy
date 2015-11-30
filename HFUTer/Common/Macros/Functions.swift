//
//  Functions.swift
//  handebiao
//
//  Created by Eliyar Eziz on 15/11/10.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import UIKit

//检查首次启动
func isAppFirstLaunchedForVersion(forVersion:String)->Bool{
  let defaults = NSUserDefaults.standardUserDefaults()
  if let _ = defaults.stringForKey("isAppAlreadyLaunchedOnce\(forVersion)"){
    print("App already launched")
    return false
  }else{
    defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce\(forVersion)")
    print("App launched first time")
    return true
  }
}

func runAfterLoginToEdu(block:()->()) {
  if DataEnv.eduUser.isLogin {
    block()
  } else {
    Hud.showMassage("请先登录教务系统")
    RootVC.showLoginToSchoolVC()
  }
}

func runAfterLoginToCommunity(block:()->()) {
  if DataEnv.eduUser.isLogin {
    if DataEnv.comUser.isLogin {
      block()
    } else {
      RootVC.showLoginToCommunityVC()
    }
  } else {
    Hud.showMassage("请先登录教务系统")
    RootVC.showLoginToSchoolVC()
  }
}

//检查表值
func isEurekaValueForKeyExist(values:[String: Any?],rowName:String) -> Bool {
  if let _ = values[rowName] as? AnyObject{
    return true
  }
  return false
}

//延迟函数
func delay(seconds seconds: Double, completion:()->()) {
  let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
  
  dispatch_after(popTime, dispatch_get_main_queue()) {
    completion()
  }
}


//图片压缩
func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
  let size = image.size
  
  let widthRatio  = targetSize.width  / image.size.width
  let heightRatio = targetSize.height / image.size.height
  
  // Figure out what our orientation is, and use that to form the rectangle
  var newSize: CGSize
  if(widthRatio > heightRatio) {
    newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
  } else {
    newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
  }
  
  // This is the rect that we've calculated out and this is what is actually used below
  let rect = CGRectMake(0, 0, newSize.width, newSize.height)
  
  // Actually do the resizing to the rect using the ImageContext stuff
  UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
  image.drawInRect(rect)
  let newImage = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  
  return newImage
}

//获取正确URL
func getUrl(yard:String,urlFor:String) -> String {
  if yard == "HF" {
    switch urlFor{
    case "LOGIN":
      return "http://ids1.hfut.edu.cn:81/amserver/UI/Login"
    case "HOMEPAGE":
      return  "http://news.hfut.edu.cn/"
    case "GET_TIMETABLE":
      return "http://bkjw.hfut.edu.cn/student/asp/grkb1.asp"
    case "GET_SCORE":
      return "http://bkjw.hfut.edu.cn/student/asp/Select_Success.asp"
    case "GET_COURSEFEE":
      return "http://bkjw.hfut.edu.cn/student/asp/Xfsf_Count.asp"
    case "GET_CLASS_LIST":
      return "http://bkjw.hfut.edu.cn/student/asp/jxbmdcx.asp"
    case "GET_CLASS_DETAIL":
      return "http://bkjw.hfut.edu.cn/student/asp/Jxbmdcx_1.asp"
    case "GET_USER_DETAIL":
      return "http://bkjw.hfut.edu.cn/student/asp/xsxxxxx.asp"
    default:
      return "http://news.hfut.edu.cn/"
    }
  } else {
    switch urlFor{
    case "LOGIN":
      return "http://222.195.8.201/pass.asp"
    case "HOMEPAGE":
      return  "http://news.hfut.edu.cn/"
    case "GET_TIMETABLE":
      return "http://222.195.8.201/student/asp/grkb1.asp"
    case "GET_SCORE":
      return "http://222.195.8.201/student/asp/Select_Success.asp"
    case "GET_COURSEFEE":
      return "http://222.195.8.201/student/asp/Xfsf_Count.asp"
    case "GET_CLASS_LIST":
      return "http://222.195.8.201/student/asp/jxbmdcx.asp"
    case "GET_CLASS_DETAIL":
      return "http://222.195.8.201/student/asp/Jxbmdcx_1.asp"
    case "GET_USER_DETAIL":
      return "http://222.195.8.201/student/asp/xsxxxxx.asp"
    default:
      return "http://news.hfut.edu.cn/"
    }
  }
}

func getComURL(api:String) -> String{
  return communityServer + api
}