//
//  BCGetClassDetailRequest.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/25.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Kanna

class BCGetClassDetailRequest {
  
  var isSucces = 0
  var handledResult = [StudentModel]()
  
  func getReques(params: NSDictionary?,onFinishedBlock:(() -> Void)?, onFailedBlock:(() -> Void)?){
    BCBaseRequest.getDataRequest(getUrl(DataEnv.eduUser.schoolYard,urlFor: "GET_CLASS_DETAIL"), params: params,
      onFinishedBlock: { (operation) -> Void in
        self.parseResult(operation.data)
        onFinishedBlock?()
      }) { (operation) -> Void in
        onFailedBlock?()
    }
    
  }
  
  func parseResult(data:NSData?) {
    
    var modelList = [StudentModel]()
    
    var nameList = [String]()
    var idList = [String]()
    
    if let htmlString:String = NSString(data:data!, encoding: GB2312Encoding) as? String{

      if let doc = HTML(html: htmlString, encoding: NSUTF8StringEncoding) {
        
        for node in doc.xpath("//table[1]//tr//td[2]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          idList.append(newString)
        }
        
        for node in doc.xpath("//table[1]//tr//td[3]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          nameList.append(newString)
        }
      }
    }
    
    if nameList.count > 1 {
      for i in 1..<nameList.count {
        let model = StudentModel()
        model.name = nameList[i]
        model.id = idList[i]
        model.serial = "\(i)"
        modelList.append(model)
      }
    }
    
    self.handledResult = modelList
  }
}