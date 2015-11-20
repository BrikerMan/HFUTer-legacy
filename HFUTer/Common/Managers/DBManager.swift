//
//  DBManager.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import FMDB

private let _SingletonASharedInstance = DBManager()

class DBManager {

  let database:FMDatabase!
  let queue:FMDatabaseQueue!

  class func sharedManager() -> DBManager {
    return _SingletonASharedInstance
  }

  init() {
    let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let path = (documentsFolder as NSString).stringByAppendingPathComponent("hfuter2.sqlite")

    self.database = FMDatabase(path: path)
    self.queue = FMDatabaseQueue(path: path)
    if !database.open() {
      print("Unable to open database")
      return
    }

    if !database.executeUpdate("create table schedule(id INTEGER PRIMARY KEY Autoincrement,name text, place text, day Int, hour Int, weeks text)", withArgumentsInArray: nil) {
      print("create table failed: \(database.lastErrorMessage())")
    }

    if !database.executeUpdate("create table scheduleMemo(id INTEGER PRIMARY KEY Autoincrement, teacherName text, memoTitle text, memoContent text, schedule_id INTEGER, FOREIGN KEY(schedule_id) REFERENCES schedule(id) )", withArgumentsInArray: nil) {
      print("create table failed: \(database.lastErrorMessage())")
    }

    if !database.executeUpdate("create table unScheduleClass(string text)", withArgumentsInArray: nil) {
      print("create table failed: \(database.lastErrorMessage())")
    }

    if !database.executeUpdate("create table grades(id INTEGER PRIMARY KEY Autoincrement,name text, code text, semester text, classNum text, score text, score2 text, credit text)", withArgumentsInArray: nil) {
      print("create table failed: \(database.lastErrorMessage())")
    }

    if !database.executeUpdate("create table courseFee(id INTEGER PRIMARY KEY Autoincrement,name text, code text,credit text, fee text,semester text)", withArgumentsInArray: nil) {
      print("create table failed: \(database.lastErrorMessage())")
    }

    if !database.executeUpdate("create table semesterFee(string text)", withArgumentsInArray: nil) {
      print("create table failed: \(database.lastErrorMessage())")
    }

    if !database.executeUpdate("create table classList(id INTEGER PRIMARY KEY Autoincrement,name text, code text,classNum text)", withArgumentsInArray: nil) {
      print("create table failed: \(database.lastErrorMessage())")
    }
  }

  //MARK: - 课表信息
  func saveScheduleModel(model:ScheduleModel) {
    queue.inDatabase { (database) -> Void in
      //model周数格式化
      var weekStr = ""
      let fm = NSNumberFormatter()
      fm.minimumIntegerDigits = 2
      for week in model.weeks {
        weekStr = weekStr + fm.stringFromNumber(week)! + ","
      }
      if !database.executeUpdate("insert into schedule (name, place, day, hour, weeks) values (?, ?, ?, ?, ?)", model.name,model.place,model.day,model.hour,weekStr) {
        print("save schedule model fail: \(database.lastErrorMessage())")
      }
    }
  }

  func updateScheduleModel(model:ScheduleModel) {
    //model周数格式化
    var weekStr = ""
    let fm = NSNumberFormatter()
    fm.minimumIntegerDigits = 2
    for week in model.weeks {
      weekStr = weekStr + fm.stringFromNumber(week)! + ","
    }

    queue.inDatabase { (database) -> Void in
      if !database.executeUpdate("update schedule set name = ?, place = ?, day = ?, hour = ?, weeks = ?  where id = ?",model.name,model.place,model.day,model.hour,weekStr,model.id) {
        print("save schedule model fail: \(database.lastErrorMessage())")
      }
    }
  }

  func deleteScheduleModel(model:ScheduleModel) {
    queue.inDatabase { (database) -> Void in
      if !database.executeUpdate("DELETE from schedule where id = ?", model.id) {
        print("save schedule model fail: \(database.lastErrorMessage())")
      }
    }
  }

  func saveUnScheduledClasses(string:String) {
    queue.inDatabase { (database) -> Void in
      if !database.executeUpdate("insert into unScheduleClass (string) values (?)", string) {
        print("save schedule model fail: \(database.lastErrorMessage())")
      }
    }
  }

  func readUnScheduledClasses() -> String{
    var string = ""
    queue.inDatabase { (database) -> Void in
      if let rs = database.executeQuery("select string from unScheduleClass", withArgumentsInArray: nil) {
        while rs.next() {
          string = rs.stringForColumn("string")
        }
      }
    }
    return string
  }

  func readScheduleModels(weekStr:String?) -> [ScheduleModel]{
    var sqliteQuery = ""
    if let weekStr = weekStr {
      sqliteQuery = "select id,name, place, day, hour,weeks from schedule where weeks like '%\(weekStr)%'"
    } else {
      sqliteQuery = "select id,name, place, day, hour,weeks from schedule"
    }

    var list = [ScheduleModel]()
    queue.inDatabase { (database) -> Void in
      if let rs = database.executeQuery(sqliteQuery, withArgumentsInArray:nil) {
        while rs.next() {
          let model = ScheduleModel()
          model.id = Int(rs.intForColumn("id"))
          model.name = rs.stringForColumn("name")
          model.place = rs.stringForColumn("place")
          model.day = Int(rs.intForColumn("day"))
          model.hour = Int(rs.intForColumn("hour"))
          let weekStr = rs.stringForColumn("weeks")
          model.weeks = weekStr.getArray()
          list.append(model)
        }
      }
    }
    return list
  }

  func deleteSchedules() {
    queue.inDatabase { (database) -> Void in
      if !database.executeUpdate("DELETE from schedule", withArgumentsInArray: nil) {
        print("delete table failed: \(database.lastErrorMessage())")
      }
      if !database.executeUpdate("DELETE from unScheduleClass", withArgumentsInArray: nil) {
        print("delete table failed: \(database.lastErrorMessage())")
      }
    }
  }


  //MARK:- Schedule Memo
  func saveScheduleMemo(memo:ScheduleMemoModel) {
    if let _ = self.readScheduleMemo(memo.schedule_id) {
      queue.inDatabase { (database) -> Void in
        if !database.executeUpdate("update scheduleMemo set teacherName = ?, memoTitle = ?, memoContent = ? where schedule_id = ?", memo.teacherName,  memo.memoTitle, memo.memoContent ,memo.schedule_id) {
          print("save schedule model fail: \(database.lastErrorMessage())")
        }
      }
    } else {
      queue.inDatabase { (database) -> Void in
        if !database.executeUpdate("insert into scheduleMemo (teacherName, memoTitle, memoContent, schedule_id) values (?,?,?,?)", memo.teacherName,  memo.memoTitle, memo.memoContent ,memo.schedule_id) {
          print("save schedule model fail: \(database.lastErrorMessage())")
        }
      }
    }
  }

  func readScheduleMemo(schedule_id:Int) -> ScheduleMemoModel?{
    var model:ScheduleMemoModel?
    let query = "select id, teacherName, memoTitle, memoContent, schedule_id from scheduleMemo where schedule_id = \(schedule_id);"
    queue.inDatabase { (database) -> Void in
      if let rs = database.executeQuery(query, withArgumentsInArray:nil) {
        while rs.next() {
          model = ScheduleMemoModel()
          model?.id = Int(rs.intForColumn("id"))
          model?.teacherName = rs.stringForColumn("teacherName")
          model?.memoTitle = rs.stringForColumn("memoTitle")
          model?.memoContent = rs.stringForColumn("memoContent")
          model?.schedule_id = schedule_id
        }
      }
    }
    return model
  }

  //MARK: - 成绩信息
  func saveGrades(model:GradeModel) {
    queue.inDatabase { (database) -> Void in
      if !database.executeUpdate("insert into grades (name, code, semester, classNum, score, score2,credit) values (?, ?, ?, ?, ?, ?, ?)", model.name,model.code,model.semester,model.classNum,model.score,model.score2,model.credit) {
        print("save schedule model fail: \(database.lastErrorMessage())")
      }
    }
  }

  func readGrades() -> [GradeModel] {
    var list = [GradeModel]()
    queue.inDatabase { (database) -> Void in
      if let rs = database.executeQuery("select name, code, semester, classNum, score, score2,credit from grades", withArgumentsInArray: nil) {
        while rs.next() {
          let model = GradeModel()
          model.name = rs.stringForColumn("name")
          model.code = rs.stringForColumn("code")
          model.semester = rs.stringForColumn("semester")
          model.classNum = rs.stringForColumn("classNum")
          model.score = rs.stringForColumn("score")
          model.score2 = rs.stringForColumn("score2")
          model.credit = rs.stringForColumn("credit")

          list.append(model)
        }
      }
    }
    return list
  }

  func deleteGrades() {
    queue.inDatabase { (database) -> Void in
      if !database.executeUpdate("DELETE from grades", withArgumentsInArray: nil) {
        print("delete table failed: \(database.lastErrorMessage())")
      }
    }
  }
}