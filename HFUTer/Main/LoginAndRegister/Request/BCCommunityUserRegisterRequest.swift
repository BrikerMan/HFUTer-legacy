//
//  BCCommunityUserRegisterRequest.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/18.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation

class BCCommunityUserRegisterRequest {
  class func register(data:String, onSuccessBlock:(() -> ())?, onFailedBlock:((reason:String?) -> ())?, onNetErrorBlock:(() -> ())?){
    let url = "http://hfut.cn-hangzhou.aliapp.com/api/user/create"
    let params = ["data":data]
    
    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params, onFinishedBlock: { (response) -> Void in
      onSuccessBlock?()
      }, onFailedBlock: { (reason) -> Void in
        onFailedBlock?(reason:reason)
      }) { () -> Void in
        onNetErrorBlock?()
    }
  }
}