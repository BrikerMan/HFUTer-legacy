//
//  EECommunityLoveWallModel.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/3.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYModel

class EECommunityLoveWallModel:NSObject {
  var content = ""
  var id      = 0
  var favoriteCount = 0
  var color   = 0   //现在表示颜色
  var name    = ""
  var image   = ""
  var date_int      = 0
  var commentCount  = 0
  var favorite      = false
  
  
  
  class func getModelsFromNetWorkForPage(page:Int,onFinishedBlock:((error:String?,models:[EECommunityLoveWallModel]?)->())?) {
    let url = getComURL("api/confession/list")
    let params = [
      "pageIndex":page
    ]
    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
      onFinishedBlock: { (response) -> Void in
        var error:String?
        var modelList:[EECommunityLoveWallModel]?
        if let array = response["data"] {
          if let models = NSArray.yy_modelArrayWithClass(EECommunityLoveWallModel.self, json: array) as? [EECommunityLoveWallModel] {
            modelList = models
          }
        } else {
          error = "数据错误"
        }
        onFinishedBlock?(error:error,models:modelList)
      }, onFailedBlock: { (reason) -> Void in
        let error = reason ?? "未知错误"
        onFinishedBlock?(error:error,models:nil)
      }) { () -> Void in
        onFinishedBlock?(error:NetErrorWarning,models:nil)
    }
  }
}