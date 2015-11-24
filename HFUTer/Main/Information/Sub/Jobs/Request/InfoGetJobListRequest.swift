//
//  InfoGetJobListRequest.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/24.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Kanna




class InfoGetJobListRequest {
  
  func get(page:Int,complitionBlock:((modelList:[InfoJobModel])->())?,failedBlock:((error:String?)->())?,netErrorBlock:(()->())?) {
    
    let url = "http://job.hfut.edu.cn/parttime.php?tid=\(page)"
    
    BCBaseRequest.getDataFromWebRequest(url, params: nil, onFinishedBlock: { (operation) -> Void in
      do {
        let modelListResult = try self.parseResult(operation.data)
        complitionBlock?(modelList:modelListResult)
      } catch {
        print("error")
        failedBlock?(error: "dsadsa")
      }
      }) { (operation) -> Void in
        netErrorBlock?()
    }
  }
  
  ////*[@id="main"]/table/tbody/tr[2]
  
  func parseResult(data:NSData?) throws -> [InfoJobModel]{
    var modelList = [InfoJobModel]()
    let enc = CFStringConvertEncodingToNSStringEncoding(0x0632)
    if let htmlString:String = NSString(data:data!, encoding: enc) as? String{
      if let doc = HTML(html: htmlString, encoding: NSUTF8StringEncoding) {
        var isFirstRow = true
        for node in doc.xpath("//table/tr") {
          if !isFirstRow {
            modelList.append(htmlToModel(node))
          } else {
            isFirstRow = false
          }
        }
      } else {
        throw RefacotorError.Terrible
      }
    }
    return modelList
  }
  
  func htmlToModel(row:XMLElement) -> InfoJobModel{
    let model = InfoJobModel()
    
    for td in row.xpath("td[1]") {
      model.name = td.text ?? ""
    }
    for td in row.xpath("td[2]") {
      model.schoolyard = td.text ?? ""
    }
    for td in row.xpath("td[3]") {
      model.time = td.text ?? ""
    }
    for td in row.xpath("td[4]") {
      model.limit = td.text ?? ""
    }
    for td in row.xpath("td[5]") {
      model.personNum = td.text ?? ""
    }
    for td in row.xpath("td[7]") {
      model.status = td.text ?? ""
    }
    for td in row.xpath("td[8]/a") {
      model.link = td["href"] ?? ""
    }
    
    return model
  }
}