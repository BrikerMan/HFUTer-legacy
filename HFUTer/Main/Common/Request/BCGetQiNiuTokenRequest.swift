//
//  BCGetQiNiuTokenRequest.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/26.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
class BCGetQiNiuTokenRequest {
  class func get(onSuccessBlock:((result:NSDictionary) -> ())?, onFailedBlock:((reason:String?) -> ())?, onNetErrorBlock:(() -> ())?){
    
    let url = getComURL("api/getQiNiuToken")
    let param = [String:AnyObject]()
    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: param,
      onFinishedBlock: { (response) -> Void in
        onSuccessBlock?(result:response)
      }, onFailedBlock: { (reason) -> Void in
        onFailedBlock?(reason:reason)
      }) { () -> Void in
        onNetErrorBlock?()
    }
  }
}