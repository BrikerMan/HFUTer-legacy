//
//  BCBaseRequest.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//
import UIKit
import Alamofire

class BCBaseRequest {
  
  var data:NSData?
  var results:NSMutableArray?
  var response:AnyObject?
  var isSuccess = false
  var error:NSError?
  
  /**
   从网页抓去信息
   */
  class func getDataFromWebRequest(url:String,params:NSDictionary?, onFinishedBlock:((operation:BCBaseRequest) -> Void)?, onFailedBlock:((operation:BCBaseRequest) -> Void)?) {
    
    let operation = BCBaseRequest()
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    
    request(Method.GET, url, parameters: params as? [String : AnyObject], encoding: ParameterEncoding.URL, headers: nil)
      .response { request, response, data, error in
        log.info("Requst:\(url)\nParams:\(params)")
        if error == nil {
          operation.data = data
          operation.response = response
          onFinishedBlock?(operation:operation)
        } else {
          operation.error = error
          onFailedBlock?(operation:operation)
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
  }
  
  /**
   用于从教务系统奇葩网站获取信息的请求
   
   - parameter url:             URl
   - parameter params:          参数
   - parameter onFinishedBlock: 结束闭包
   - parameter onFailedBlock:   失败闭包
   */
  class func getDataRequest(url:String,params:[String : AnyObject]?, onFinishedBlock:((operation:BCBaseRequest) -> Void)?, onFailedBlock:((operation:BCBaseRequest) -> Void)?) {
    let action = {
      let operation = BCBaseRequest()
      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      
      request(Method.GET, url, parameters: params, encoding: ParameterEncoding.URL, headers: nil)
        .response { request, response, data, error in
          log.info("Requst:\(url)\nParams:\(params)")
          if error == nil {
            operation.data = data
            operation.response = response
            onFinishedBlock?(operation:operation)
          } else {
            operation.error = error
            onFailedBlock?(operation:operation)
          }
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      }
    }
    
    DataEnv.getEduUserToken { (sccess, error) -> () in
      if sccess {
        action()
      } else {
        Hud.showError(error)
      }
    }
  }
  
  /**
   获取Json请求
   - parameter response.request    original URL request
   - parameter response.response   URL response
   - parameter response.data       server data
   - parameter response.result     result of response serialization
   */
  class func getJsonRequest(url:String ,params:NSDictionary, onFinishedBlock:((response:NSDictionary) -> Void)?, onFailedBlock:((error:NSError?) -> Void)?) {
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    
    request(Method.GET, url, parameters: params as? [String : AnyObject], encoding: ParameterEncoding.URL, headers: nil)
      .responseJSON(completionHandler: { (response) -> Void in
        log.info("Requst:\(url)\nParams:\(params)")
        
        
        if let _ = response.result.value ,let dic = response.result.value as? NSDictionary{
          onFinishedBlock?(response:dic)
        }
      })
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
  
  
  /**
   从社区服务器获取数据
   
   - parameter response.request    original URL request
   - parameter response.response   URL response
   - parameter response.data       server data
   - parameter response.result     result of response serialization
   */
  class func getJsonFromCommunityServerRequest(url:String ,params:[String:AnyObject], onFinishedBlock:((response:NSDictionary) -> Void)?, onFailedBlock:((reason:String?) -> Void)?,onNetErrorBlock:(() -> Void)?) {
    
    let header = ["Cookie":DataEnv.comUser.cookie]
    log.request(url, param: params,header:header)
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    
    request(.POST, url, parameters: params, encoding: ParameterEncoding.URL, headers: header)
      .responseJSON(completionHandler: { (response) -> Void in
        if let dic = response.result.value as? NSDictionary {
          print(response.result.value)
          if dic["statue"] as? Bool == true {
            DataEnv.saveCookie(response.response?.allHeaderFields["Set-Cookie"] as? String)
            onFinishedBlock?(response:dic)
          } else {
            onFailedBlock?(reason:dic["info"] as? String)
          }
        } else {
          onNetErrorBlock?()
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      })
    
  }
}