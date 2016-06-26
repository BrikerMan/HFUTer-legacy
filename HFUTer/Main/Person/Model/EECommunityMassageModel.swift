//
//  CommunityMassageModel.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation

class EECommunityMassageModel: NSObject {
  
  var id = 0
  var date_int = 0
  var message = ""
  var sImage = ""
  var name   = ""
  
  class func getListFromServer(type:Int,page:Int,onFinishedBlock:((error:String?,models:[EECommunityMassageModel]?)->())?) {
    let url =  getComURL("api/user/messageList")
    let params = [
      "type":type,
      "pageIndex":page
    ]
    
    BCBaseRequest.getJsonFromCommunityServerRequest(url,
      params: params,
      onFinishedBlock: { (response) -> Void in
        var models = [EECommunityMassageModel]()
        if let array = response["data"] as? NSArray {
          for json in array {
            let model = EECommunityMassageModel.yy_modelWithJSON(json)!
            models.append(model)
          }
          onFinishedBlock?(error:nil,models:models)
        } else {
          onFinishedBlock?(error:"解析错误",models:nil)
        }
        
      }, onFailedBlock: { (reason) -> Void in
        onFinishedBlock?(error:reason,models:nil)
      }) { () -> Void in
        onFinishedBlock?(error:NetErrorWarning,models:nil)
    }
  }
}