//
//  EECommunityLoveCommentModel.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/3.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
class EECommunityLoveCommentModel:NSObject {
  var content = ""
  var date_int  = 0
  var id = 0
  var image = ""
  var name = ""
  var uid = 0
  var at = [CommunityUserModel]()
  
  
  class func getModelsFromNetWorkForPage(page:Int,model_id:Int,onFinishedBlock:((error:String?,models:[EECommunityLoveCommentModel]?)->())?) {
    let url = getComURL("api/confession/commentList")
    let params = [
      "pageIndex":page,
      "id":model_id
    ]
    
    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
      onFinishedBlock: { (response) -> Void in
        var models = [EECommunityLoveCommentModel]()
        if let jsons = response["data"] as? [NSDictionary] {
          for json in jsons {
            let model = EECommunityLoveCommentModel.yy_modelWithJSON(json)
            
            if let atUserList = json["at"] as? Array<AnyObject> {
              for items in atUserList {
                let user = CommunityUserModel.yy_modelWithJSON(items)
                model.at = [user]
              }
            }
            models.append(model)
            print(model)
          }
          onFinishedBlock?(error:nil,models:models)
        } else {
          onFinishedBlock?(error:"解析错误",models:nil)
        }
      }, onFailedBlock: { (reason) -> Void in
        let error = reason ?? "未知错误"
        onFinishedBlock?(error:error,models:nil)
      }) { () -> Void in
        onFinishedBlock?(error:NetErrorWarning,models:nil)
    }
  }
}