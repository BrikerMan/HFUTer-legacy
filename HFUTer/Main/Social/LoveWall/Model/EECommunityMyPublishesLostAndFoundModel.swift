//
//  EECommunityMyPublishesLostAndFoundModel.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/3.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
class EECommunityMyPublishesLostAndFoundModel:NSObject {
  
  var id = 0
  var content = ""
  var date_int = 0
  var pic = [String]()
  var statue = 0
  
  //标记为结束
  func markAsFinished(onFinishedBlock:((error:String?,model:EECommunityMyPublishesLostAndFoundModel?)->())?) {
    let url =  getComURL("api/lostFound/markFinish")
    let params = [
      "id":self.id
    ]
    
    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
      onFinishedBlock: { (response) -> Void in
        self.statue = 1
        onFinishedBlock?(error:nil,model:self)
      }, onFailedBlock: { (reason) -> Void in
        onFinishedBlock?(error:reason,model:nil)
      }) { () -> Void in
        onFinishedBlock?(error:NetErrorWarning,model:nil)
    }
  }
  
  class func getModelsFromNetWorkForPage(page:Int,onFinishedBlock:((error:String?,models:[EECommunityMyPublishesLostAndFoundModel]?)->())?) {
    let url = getComURL("api/user/lostFoundList")
    let params = [
      "pageIndex":page
    ]
    
    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
      onFinishedBlock: { (response) -> Void in
        var models = [EECommunityMyPublishesLostAndFoundModel]()
        if let jsons = response["data"] as? [NSDictionary] {
          for json in jsons {
            let model = EECommunityMyPublishesLostAndFoundModel.yy_modelWithJSON(json)
            models.append(model)
            print(model)
          }
          onFinishedBlock?(error:nil,models:models)
        }
      }, onFailedBlock: { (reason) -> Void in
        onFinishedBlock?(error:reason,models:nil)
      }) { () -> Void in
        onFinishedBlock?(error:NetErrorWarning,models:nil)
    }
  }
}