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
  var status = 0
  
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
        print(reason)
      }) { () -> Void in
        
    }
  }
}