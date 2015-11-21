//
//  BCCommunityUserLoginRequest.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/21.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation

class BCCommunityUserLoginRequest {
  class func login(username:String,password:String,onSuccessBlock:((response:NSDictionary) -> ())?, onFailedBlock:((reason:String?) -> ())?, onNetErrorBlock:(() -> ())?){
    let url = "http://hfut.cn-hangzhou.aliapp.com/api/user/login"
    let params = [
      "sid":username,
      "pwd":MD5Encryption.md5by32(password)
    ]

    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
      onFinishedBlock: { (response) -> Void in
        onSuccessBlock?(response:response)
      }, onFailedBlock: { (reason) -> Void in
        onFailedBlock?(reason:reason)
      }) { () -> Void in
        onNetErrorBlock?()
    }
  }
}