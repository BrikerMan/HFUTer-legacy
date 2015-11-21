//
//  BCLostAndFoundModel.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/18.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation

class BCLostAndFoundModel:JSONNDModel {
  var sid = ""
  var content = ""
  var id = 0
  var statue = 0
  var image = ""
  var pic = [String]()
  var type = 0
  var date:Int64 = 0
  var name = ""
  
  
  class func getPicList(jsonItem:JSONND) -> [String]{
    var picList = [String]()
    if let jsonArray = jsonItem["pic"].array {
      for jsonItem in jsonArray {
        if let pic = jsonItem.string {
          picList.append(pic)
        }
      }
    }
    return picList
  }
  
  
}