//
//  BCGetUserDetailFromEduRequest.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/22.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Kanna

class BCGetUserDetailFromEduRequest {
  static func get(user:EduUser,onSuccessGetBlock:(() -> Void)?,onParseFailBlock:(() -> Void)?,onFailGetRequest:(() -> Void)?) {
    BCBaseRequest.getDataRequest(getUrl(DataEnv.eduUser.schoolYard,urlFor: "GET_USER_DETAIL"), params: nil,
      onFinishedBlock: { (operation) -> Void in
        let userWithDetail = self.getDetail(operation.data,user:user)
        DataEnv.saveEduUser(userWithDetail)
        onSuccessGetBlock?()
      }) { (operation) -> Void in
        onFailGetRequest?()
    }
  }
  
  static func getDetail(data:NSData?,user:EduUser) -> EduUser{
    let enc = CFStringConvertEncodingToNSStringEncoding(0x0632)
    if let htmlString:String = NSString(data:data!, encoding: enc) as? String{
      if let doc = HTML(html: htmlString, encoding: NSUTF8StringEncoding) {
        //获取名字
        for node in doc.xpath("//table[1]//tr[2]//td[2]") {
          if let name = node.text {
            user.name = name[3..<name.characters.count]
          }
        }
        
        //获取性别
        for node in doc.xpath("//table[1]//tr[2]//td[3]") {
          if let text = node.text {
            if text.characters.count > 5 {
              let newString = text[5..<text.characters.count]
              user.gender = newString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            }
          }
          
        }
        
        //学院
        for node in doc.xpath("//table[1]//tr[5]//td[1]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          user.academy = newString
        }
        
        //学院
        for node in doc.xpath("//table[1]//tr[5]//td[1]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          user.academy = newString
        }
        
        //专业
        for node in doc.xpath("//table[1]//tr[5]//td[2]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          user.major = newString
        }
        
        //班级
        for node in doc.xpath("//table[1]//tr[5]//td[3]") {
          let newString = node.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
          user.className = newString
        }
      }
    }
    return user
  }
}
