//
//  BCGetClassListRequest.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/25.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Kanna

class BCGetClassListRequest:BCBaseRequest {
  
  /* 0 成功
  * 1 数据错误
  * 2 登录错误
  * 3
  * 4 需要评估 */
  var isSucces = 0
  var classListModels = [ClassListModel]()
  
  func getRequest(onFinishedBlock:(() -> Void)?, onFailedBlock:(() -> Void)?,onLoginFailBlock:(() -> Void)?) {
    BCBaseRequest.getDataRequest(getUrl(DataEnv.eduUser.schoolYard,urlFor: "GET_CLASS_LIST"), params: nil ,
      onFinishedBlock: { (operation) -> Void in
        self.classListModels.removeAll()
        self.parseResult(operation.data)
        if self.isSucces == 0 {
          onFinishedBlock?()
        } else if self.isSucces == 2{
          onLoginFailBlock?()
        } else {
          onFailedBlock?()
        }
      }, onFailedBlock: { (operation) -> Void in
        
    })
  }
  
  func parseResult(data:NSData?) {
    var codeList = [String]()
    var nameList = [String]()
    var classList = [String]()
    
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
        
        var isFirst = true
        for node in doc.xpath("//table[1]//tr//td[1]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          if isFirst {
            isFirst = false
          } else {
            codeList.append(newString)
          }
          
        }
        
        for node in doc.xpath("//table[1]//tr//td[2]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          nameList.append(newString)
        }
        
        
        for node in doc.xpath("//table[1]//tr//td[3]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          classList.append(newString)
        }
        
      }
    }
    
    for i in 1..<nameList.count {
      let model = ClassListModel()
      model.name = nameList[i]
      model.code = codeList[i]
      model.classNum = classList[i]
      classListModels.append(model)
    }
  }
}