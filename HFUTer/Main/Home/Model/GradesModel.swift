//
//  GradesModel.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
class GradeModel {
  var id = 0
  var code = ""
  var name = ""
  var semester = ""
  var classNum = ""
  var score = ""
  var score2 = ""
  var credit = ""
  
  
  static func saveGrade(model:GradeModel) {
    DBManager.sharedManager().saveGrades(model)
  }
  
  static func delteGrades() {
    DBManager.sharedManager().deleteGrades()
  }
  
  static func calculateGPA() -> [SemesterModel]{
    let semesterList = self.getGradesBySemester()
    
    var list = [SemesterModel]()
    
    for semester in semesterList {
      let result = calculateSemesterGPA(semester)
      list.append(result)
    }
    
    return list
  }
  
  static func calculateAllGPA() -> SemesterModel {
    let allGrades = DBManager.sharedManager().readGrades()
    let result = calculateSemesterGPA(allGrades)
    return result
  }
  
  static func calculateSemesterGPA(semester:[GradeModel]) -> SemesterModel{
    var gpas:Float = 0
    var allCridet:Float = 0
    var gongxuanCridet:Float = 0
    var cridetAndScore:Float = 0
    var semsterName = ""
    for grade in semester {
      let gpa = Calculator.calculateGPA(grade.score)
      let cridetStr = grade.credit as NSString
      let cridet = cridetStr.floatValue
      if grade.code.lowercaseString.hasSuffix("0x") {
        gpas = gpas + gpa * cridet
        cridetAndScore = cridetAndScore + Float(Calculator.calculateAverage(grade.score)) * cridet
        allCridet = allCridet + cridet
      } else if grade.code.lowercaseString.hasSuffix("x"){
        gongxuanCridet = gongxuanCridet + cridet
      } else {
        gpas = gpas + gpa * cridet
        cridetAndScore = cridetAndScore + Float(Calculator.calculateAverage(grade.score)) * cridet
        allCridet = allCridet + cridet
      }
      semsterName = grade.semester
    }
    let GPA = gpas/allCridet
    let average = (cridetAndScore)/allCridet
    let semester = SemesterModel()
    semester.name = semsterName
    semester.gpa = GPA
    semester.average = average
    semester.gongxuanXuefen = gongxuanCridet
    
    return semester
  }
  
  static func getGradesBySemester() -> [[GradeModel]]{
    let gradesList = DBManager.sharedManager().readGrades()
    var semesterList = [[GradeModel]]()
    
    var semester = [GradeModel]()
    var lastSemesterString = ""
    var semesterCode = 0
    
    for grade in gradesList {
      if grade.semester != lastSemesterString {
        if lastSemesterString != "" {
          semesterList.append(semester)
        }
        semesterCode += 1
        semester = [GradeModel]()
        semester.append(grade)
      } else {
        semester.append(grade)
      }
      lastSemesterString = grade.semester
    }
    semesterList.append(semester)
    return semesterList
  }
}