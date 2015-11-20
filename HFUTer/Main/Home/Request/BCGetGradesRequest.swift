//
//  BCGetGradesRequest.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Kanna

class BCGetGradesRequest:BCBaseRequest {
  
  /* 0 成功
  * 1 数据错误
  * 2 登录错误
  * 3
  * 4 需要评估 */
  var isSucces = 0
  
  func getRequest(onFinishedBlock:(() -> Void)?, onFailedBlock:((error:String?) -> Void)?) {
    BCBaseRequest.getDataRequest(getUrl(DataEnv.eduUser.schoolYard,urlFor: "GET_SCORE"), params: nil,
      onFinishedBlock: { (operation) -> Void in
        GradeModel.delteGrades()
        self.parseResult(operation.data)
        if self.isSucces == 0 {
          onFinishedBlock?()
        } else if self.isSucces == 2{
          onFailedBlock?(error: "登录出错，请重新登录或重启App")
        } else {
          onFailedBlock?(error:"未知错误，请联系作者")
        }
      }, onFailedBlock: { (operation) -> Void in
    })
  }
  
  func parseResult(data:NSData?) {
    var courseID = [String]()
    var courseName = [String]()
    var semester = [String]()
    var classNum = [String]()
    var courseScore = [String]()
    var courseBukaoScore = [String]()
    var courseCredit = [String]()
    
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
        //解析补考成绩，未及格成绩
        func Refactor(srt:String) -> String {
          var count1 = 0
          var count2 = 0
          var startIndex = 0
          var endIndex = 0
          var index = 0
          for i in srt.characters {
            if i == ">" {
              count1 = count1 + 1
              if count1 == 2 {startIndex = index}
            }
            if i == "<" {
              count2 = count2 + 1
              if count2 == 3 {endIndex = index}
            }
            
            index = index + 1
          }
          if count1 == 4 {
            return (srt[startIndex + 1..<endIndex])
          } else {
            return ""
          }
        }
        
        for node in doc.xpath("//table[1]//tr//td[1]") {
          semester.append(node.text!)
        }
        
        for node in doc.xpath("//table[1]//tr//td[2]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          courseID.append(newString)
        }
        
        for node in doc.xpath("//table[1]//tr//td[3]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          courseName.append(newString)
        }
        
        for node in doc.xpath("//table[1]//tr//td[4]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          classNum.append(newString)
        }
        
        for node in doc.xpath("//table[1]//tr//td[5]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          if newString == "" {
            let srt = Refactor(node.innerHTML!)
            courseScore.append(srt)
          } else {
            courseScore.append(newString)
          }
        }
        
        for node in doc.xpath("//table[1]//tr//td[6]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          if newString == "" {
            let srt = Refactor(node.innerHTML!)
            courseBukaoScore.append(srt)
          } else {
            courseBukaoScore.append(newString)
          }
        }
        
        for node in doc.xpath("//table[1]//tr//td[7]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          if newString == ".5" {
            courseCredit.append("0.5")
          } else {
            courseCredit.append(node.text!)
          }
        }
      }
    } else {
      isSucces = 1
    }
    
    for index in 1..<courseID.count {
      let model = GradeModel()
      model.code = courseID[index]
      model.name = courseName[index]
      model.semester = semester[index]
      model.classNum = classNum[index]
      model.score = courseScore[index]
      model.score2 = courseBukaoScore[index]
      model.credit = courseCredit[index]
      
      GradeModel.saveGrade(model)
    }
    GradeModel.calculateGPA()
  }
}