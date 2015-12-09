//
//  File.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation

class BClog {
  
  static func log(info:String, file:String = __FILE__, method:String = __FUNCTION__, line: Int = __LINE__) {
    let str = "\(file)[\(line)]-\(method):\(info)"
    print(str)
  }
  
  static func info(info:String) {
    let date = NSDate(timeIntervalSinceNow: 0)
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let dataString = formatter.stringFromDate(date)
    let str = "[\(dataString)] " + "INFO:" + info
    print(str)
    
  }

  static func error(info:String,param:[String:AnyObject]?) {
    let date = NSDate(timeIntervalSinceNow: 0)
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let dataString = formatter.stringFromDate(date)
    let str = "[\(dataString)] " + "ERROR:" + info + "\nParam:\(param)"
    #if DEBUG
      print(str)
    #endif
  }

  static func request(url:String,param:NSDictionary?,header:NSDictionary?) {
    let date = NSDate(timeIntervalSinceNow: 0)
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let dataString = formatter.stringFromDate(date)
    let str = "=====================\(dataString)=====================\n" + "REQUEST:" + url + "\nHeader:\(header)" + "\nParam:\(param)"
    #if DEBUG
      print(str)
    #endif
  }
}