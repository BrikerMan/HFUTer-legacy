//
//  ScheduleMemoModel.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/10.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
class ScheduleMemoModel {
  var id = 0
  var schedule_id = 0
  var teacherName = ""
  var memoTitle   = ""
  var memoContent = ""
  
  class func saveMemo(memo:ScheduleMemoModel) {
    DBManager.sharedManager().saveScheduleMemo(memo)
  }
  
  
  class func readMemo(schedule_id:Int) -> ScheduleMemoModel{
    return DBManager.sharedManager().readScheduleMemo(schedule_id) ?? ScheduleMemoModel()
  }
}