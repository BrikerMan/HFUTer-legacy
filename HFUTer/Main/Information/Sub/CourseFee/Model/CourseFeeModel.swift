//
//  CourseFeeModel.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/25.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
class CourseFeeModel {
  var code = ""
  var name = ""
  var fee = ""
  var credit = ""
  var semester = ""
  
  class func readFeesBySemester(FeeList:[CourseFeeModel]) -> [[CourseFeeModel]]{
    var semesterList = [[CourseFeeModel]]()
    
    var semester = [CourseFeeModel]()
    var lastSemesterString = ""
    var semesterCode = 0
    
    for fee in FeeList {
      if fee.semester != lastSemesterString {
        if lastSemesterString != "" {
          semesterList.append(semester)
        }
        semesterCode += 1
        semester = [CourseFeeModel]()
        semester.append(fee)
      } else {
        semester.append(fee)
      }
      lastSemesterString = fee.semester
    }
    semesterList.append(semester)
    return semesterList
  }
  
}