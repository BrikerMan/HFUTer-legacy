//
//  NewsCategories.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/23.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation

class NewsCategories {
  var title = ""
  var type = ""
  var picName = ""
  
  static func get() -> [NewsCategories] {
    var c = ["工大要闻",
      "通知公告",
      "报告讲座",
      "媒体工大",
      "综合新闻",
      "教学科研",
      "合作交流",
      "工大人物",
      "校友风采",
      "多彩校园",
      "教育视点",
      "科技视点"]
    
    var i = ["top",
      "announce",
      "buy",
      "lecture",
      "media",
      "topscience",
      "student",
      "people",
      "school",
      "education",
      "science",
      "student",
      "people",
      "school",
      "education",
      "science"]
    
    var items = [NewsCategories]()
    
    for var index = 0; index < c.count; ++index {
      let item = NewsCategories()
      item.title = c[index]
      item.picName = i[index]
      item.type = "\(index+1)"
      items.append(item)
    }
    
    return items
  }
}