//
//  BCGetSceduleRequest.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Kanna

enum RefacotorError: ErrorType {
  case WrongRawString
  case Worse
  case Terrible
}

class BCGetSceduleRequest:BCBaseRequest {
  
  /* 0 成功
  * 1 数据错误
  * 2 登录错误
  * 3
  * 4 需要评估 */
  var isSucces = 0
  
  func getRequest(onFinishedBlock onFinishedBlock:(() -> Void)?, onFailedBlock:((error:String?) -> Void)?) {
    BCBaseRequest.getDataRequest(getUrl(DataEnv.eduUser.schoolYard,urlFor: "GET_TIMETABLE"), params: nil, onFinishedBlock: { (operation) -> Void in
      ScheduleModel.deleteAllSchedule()
      self.parseResult(operation.data)
      if self.isSucces == 0 {
        onFinishedBlock?()
      } else if self.isSucces == 2{
        onFailedBlock?(error: "登录出错，请重新登录或重启App")
      } else {
        onFailedBlock?(error: "未知错误，请联系作者")
      }
      }, onFailedBlock: { (operation) -> Void in
        
    })
  }
  
  func parseResult(data:NSData?) {
    let enc = CFStringConvertEncodingToNSStringEncoding(0x0632)
    if let htmlString:String = NSString(data:data!, encoding: enc) as? String{
      if htmlString == "" || htmlString.contains("类型不匹配"){
        isSucces = 2
        return
      }
      
      if htmlString.contains("参加评价") {
        isSucces = 4
        return
      }
      if let doc = HTML(html: htmlString, encoding: NSUTF8StringEncoding) {
        var  Monday = [String]()
        for node in doc.xpath("//table[2]//tr//td[2]") {
          Monday.append(node.text!)
        }
        
        //周二课表
        var  Tuesday = [String]()
        for node in doc.xpath("//table[2]//tr//td[3]") {
          Tuesday.append(node.text!)
        }
        
        //周三课表
        var  Wednesday = [String]()
        for node in doc.xpath("//table[2]//tr//td[4]") {
          Wednesday.append(node.text!)
        }
        
        //周四课表
        var  Thursday = [String]()
        for node in doc.xpath("//table[2]//tr//td[5]") {
          Thursday.append(node.text!)
        }
        
        //周五课表
        var  Friday  = [String]()
        for node in doc.xpath("//table[2]//tr//td[6]") {
          Friday.append(node.text!)
        }
        
        //周六课表
        var  Saturday = [String]()
        for node in doc.xpath("//table[2]//tr//td[7]") {
          Saturday.append(node.text!)
        }
        
        var  Sunday = [String]()
        for node in doc.xpath("//table[2]//tr//td[8]") {
          Sunday.append(node.text!)
        }
        if Monday.count >  Tuesday.count {
          ScheduleModel.saveUnScheduleClasses(Monday.last!)
        } else {
          ScheduleModel.saveUnScheduleClasses("")
        }
        let courseList:[[String]] = [Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday]
        self.refactureResult(courseList)
      }
    }
  }
  
  func refactureResult(courseList:[[String]]) {
    
    for h in [1,3,5,7,9] {
      for d in 0...6 {
        let course = courseList[d][h+1]
        if course != "" {
          do {
            try seperateWeeks(course, day: d, time: h)
          }
          catch _ {
            
          }
        }
      }
    }
  }
  
  func seperateWeeks(row:String,day:Int,time:Int) throws {
    if row.characters.contains("[") && row.characters.contains("]") && row.characters.contains("(") && row.characters.contains(")") {
      if row.characters.contains("/") {
        let subIndexs:[Int] = row.getIndexsOf("/")
        if subIndexs.count == 1 {
          partheString(row, day: day, time: time)
        } else {
          for i in 0..<subIndexs.count-1 {
            partheString(row[subIndexs[i]+i..<subIndexs[i+1]], day: day, time: time)
          }
        }
        
      } else {
        
      }
    } else {
      throw RefacotorError.WrongRawString
    }
  }
  
  func getWeekNum(var str:String) -> [Int]{
    var results = [Int]()
    var weekList = [Int]()
    
    var isDoubleWeek = false
    var isSingleWeek = false
    if str.characters.contains(",") {
      str = str[1..<str.characters.count]
    }
    
    if str.characters.contains("(") {
      str = str[1..<str.characters.count]
    }
    
    if str.characters.contains("-") {
      var index = -1
      for char in str.characters {
        index += 1
        if char == "-" {
          if let num:Int = Int(str[0..<index]) {
            results.append(num)
          }
          if str.characters.contains("双") {
            if let num:Int = Int(str[index+1..<str.characters.count-2]) {
              isDoubleWeek = true
              results.append(num)
            }
          } else if str.characters.contains("单") {
            if let num:Int = Int(str[index+1..<str.characters.count-2]) {
              isSingleWeek = true
              results.append(num)
            }
          } else if str.characters.contains("周") {
            if let num:Int = Int(str[index+1..<str.characters.count-1]) {
              results.append(num)
            }
          } else {
            if let num:Int = Int(str[index+1..<str.characters.count]) {
              results.append(num)
            }
          }
        }
      }
      
      if results.count == 2 {
        for i in results[0]...results[1] {
          if isDoubleWeek {
            if i % 2 == 0 { weekList.append(i) }
          } else if isSingleWeek {
            if i % 1 == 0 { weekList.append(i) }
          } else {
            weekList.append(i)
          }
          
        }
      }
      
    } else {
      if str.characters.contains("周") {
        str = str[0..<str.characters.count-1]
      }
      if let num = Int(str) {
        weekList.append(num)
      }
    }
    return weekList
  }
  
  
  func partheString(weekStr:String,day:Int,time:Int) {
    let model = ScheduleModel()
    
    //课程名字
    let nameEndIndex = weekStr.getIndexOf("[")
    if weekStr.characters.contains("/") {
      model.name = weekStr[1..<nameEndIndex]
    } else {
      model.name = weekStr[0..<nameEndIndex]
    }
    
    //课程地点
    let detailStr = weekStr.getStringBetween("[", char2: "]")
    let placeStartIndex = detailStr.getIndexOf("[")
    let placeEndIndex = detailStr.getIndexOf("(")
    if placeStartIndex<placeEndIndex {
      model.place = detailStr[placeStartIndex+1..<placeEndIndex]
    } else {
      print("课程地点获取错误 - \(detailStr)")
    }
    
    //课程周数
    var weeksSeperated = [String]()
    let weeknames = weekStr.getStringBetween("(", char2: ")")
    if weeknames.characters.contains(",") {
      weeksSeperated = weeknames.seperateBy(",")
    } else {
      weeksSeperated = [weeknames]
    }
    
    var after = [Int]()
    for sep in weeksSeperated {
      after.appendContentsOf(getWeekNum(sep))
    }
    model.weeks = after
    
    //课时
    var hour = 0
    switch time {
    case 1:
      hour = 0
    case 3:
      hour = 1
    case 5:
      hour = 2
    case 7:
      hour = 3
    case 9:
      hour = 4
    default:
      print("*****SOME THING WRONG******")
    }
    
    //周一到周五存为1-5，课时也存为1-5.不从0开始
    model.day = day + 1
    model.hour = hour + 1
    
    ScheduleModel.saveSchedule(model)
  }
}