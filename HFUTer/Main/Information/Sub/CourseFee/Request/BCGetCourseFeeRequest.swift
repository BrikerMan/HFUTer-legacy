//
//  BCGetCourseFeeRequest.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/25.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Kanna

class BCGetCourseFeeRequest {
  
  /* 0 成功
  * 1 数据错误
  * 2 登录错误
  * 3
  * 4 需要评估 */
  var isSucces = 0
  
  func getRequest(onFinishedBlock:((CourseFeeList:[CourseFeeModel], semesterList:[String]) -> Void)?, onFailedBlock:(() -> Void)?,onLoginFailBlock:(() -> Void)?) {
    BCBaseRequest.getDataRequest(getUrl(DataEnv.eduUser.schoolYard,urlFor: "GET_COURSEFEE"), params: nil,
      onFinishedBlock: { (operation) -> Void in
        let result = self.parseResult(operation.data)
        if self.isSucces == 0 {
          onFinishedBlock?(CourseFeeList:result.0, semesterList:result.1)
        } else if self.isSucces == 2 {
          onLoginFailBlock?()
        } else {
          onFailedBlock?()
        }
      }, onFailedBlock: { (operation) -> Void in
        
    })
  }
  
  func parseResult(data:NSData?) -> ([CourseFeeModel],[String]){
    var codeList = [String]()
    var nameList = [String]()
    var creditList = [String]()
    var semesterList = [String]()
    var feeList = [String]()
    var semesterFeeList = [String]()
    
    var courseFeeList = [CourseFeeModel]()
    
    let enc = CFStringConvertEncodingToNSStringEncoding(0x0632)
    if let htmlString:String = NSString(data:data!, encoding: enc) as? String{
      if htmlString == "" || htmlString.contains("类型不匹配"){
        isSucces = 2
        return (courseFeeList,semesterFeeList)
      }
      
      if htmlString.contains("参加评价") {
        isSucces = 4
        return (courseFeeList,semesterFeeList)
      }
      
      if let doc = HTML(html: htmlString, encoding: NSUTF8StringEncoding) {
        
        for node in doc.xpath("//table[1]//tr//td[1]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          if newString.contains("注册") {
            semesterFeeList.append(newString)
          } else {
            semesterList.append(newString)
          }
        }
        
        for node in doc.xpath("//table[1]//tr//td[2]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          codeList.append(newString)
        }
        
        for node in doc.xpath("//table[1]//tr//td[3]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          nameList.append(newString)
        }
        
        for node in doc.xpath("//table[1]//tr//td[5]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          if newString == ".5"{
            creditList.append("0.5")
          } else {
            creditList.append(newString)
          }
        }
        
        for node in doc.xpath("//table[1]//tr//td[6]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          feeList.append(newString)
        }
      }
    }
    
    for i in 1..<nameList.count {
      let model = CourseFeeModel()
      model.name = nameList[i]
      model.code = codeList[i]
      model.fee = feeList[i]
      model.credit = creditList[i]
      model.semester = semesterList[i]
      courseFeeList.append(model)
    }
    
    return (courseFeeList,semesterFeeList)
  }
}