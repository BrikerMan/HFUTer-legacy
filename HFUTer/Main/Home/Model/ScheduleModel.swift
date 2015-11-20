//
//  ScheduleModel.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
class ScheduleModel {
  var id = 0
  var name = ""
  var place = ""
  var day = 0
  var hour = 0
  var startWeek = 0
  var endWeek = 0
  var weeks = [Int]()
  
  class func classTimeToString(time:Int?) -> String? {
    let list = ["1-2节", "3-4节", "5-6节", "7-8节", "9-11节","1-2节", "3-4节", "5-6节", "7-8节", "9-11节"]
    if let time = time { return list[time-1] }
    return nil
  }
  
  class func timeStringToInt(string:String) -> Int {
    let list = ["","1-2节", "3-4节", "5-6节", "7-8节", "9-11节"]
    let index = list.indexOf(string) ?? 0
    return index
  }
  
  class  func dayToString(day:Int?) -> String {
    let list = ["","星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]
    if let day = day { return list[day] }
    return  ""
  }
  
  class  func stringToDay(string:String) -> Int {
    let list = ["","星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]
    let index = list.indexOf(string) ?? 0
    return index
  }
  
  class func saveSchedule(id:Int,name:String,place:String,day:Int,hour:Int,startweek:Int,endWeek:Int) {
    let temp = ScheduleModel()
    temp.id = id
    temp.name = name
    temp.place = place
    temp.day = day
    temp.hour = hour
    temp.startWeek = startweek
    temp.endWeek = endWeek
  }
  
  class func readScheduleModelForWeek(week:Int?) -> [ScheduleModel]{
    var weekStr:String?
    let fm = NSNumberFormatter()
    fm.minimumIntegerDigits = 2
    if let week = week, str = fm.stringFromNumber(week) {
      weekStr = str
    }
    return DBManager.sharedManager().readScheduleModels(weekStr)
  }
  
  class func saveSchedule(model:ScheduleModel) {
    DBManager.sharedManager().saveScheduleModel(model)
  }
  
  class func saveUnScheduleClasses(classes:String) {
    DBManager.sharedManager().saveUnScheduledClasses(classes)
  }
  
  class func updateSchedule(model:ScheduleModel) {
    DBManager.sharedManager().updateScheduleModel(model)
  }
  
  class func deleteSchedule(model:ScheduleModel) {
    DBManager.sharedManager().deleteScheduleModel(model)
  }
  
  class func deleteAllSchedule() {
    DBManager.sharedManager().deleteSchedules()
  }
}
