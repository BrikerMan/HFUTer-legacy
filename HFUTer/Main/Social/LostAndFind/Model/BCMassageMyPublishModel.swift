//
//  BCMassageMyPublishModel.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/19.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCMassageMyPublishModel:JSONNDModel {
  var content = ""
  var id = 0
  var statue = 0
  var pic = [String]()
  var date:Int64 = 0
  
  
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
