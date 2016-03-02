//
//  calculator.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/9/12.
//  Copyright (c) 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
class Calculator {
  
  static func calculateAverage(score:String) -> Int{
    switch score{
    case "优":
      return 95
    case "良":
      return 85
    case "中":
      return 75
    case "及格":
      return 60
    case "不及格":
      return 50
    case "未考":
      return 0
    case "免修":
      return 95
    default:
      if let mark = Int(score) {
        return mark
      } else {
        return 0
      }
    }
  }
  
  
  
  static func calculateGPA(score:String) -> Float{
    switch score{
    case "优":
      return 3.9
    case "良":
      return 3.0
    case "中":
      return 2.0
    case "及格":
      return 1.0
    case "旷考","不及格","未考":
      return 0.0
    case "免修":
      return 0
    default:
      if let mark = Int(score) {
        if mark <= 100 && mark >= 95{
          return 4.3
        } else if mark >= 90 {
          return 4.0
        } else if mark >= 85 {
          return 3.7
        } else if mark >= 82 {
          return 3.3
        } else if mark >= 78 {
          return 3.0
        } else if mark >= 75 {
          return 2.7
        } else if mark >= 72 {
          return 2.3
        } else if mark >= 68 {
          return 2.0
        } else if mark >= 66 {
          return 1.7
        } else if mark >= 64 {
          return 1.3
        } else if mark >= 60 {
          return 1
        } else {
          return 0
        }
      } else {
        return 0.0
      }
    }
  }
}