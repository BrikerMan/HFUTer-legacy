//
//  InfoGetBooksListRequest.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/1.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

class InfoGetBooksListRequest {
  
  var error:String?
  
  func get(onSucceedBlock:(()->())?,onFailedBlock:((error:String?)->())?,onNetErrorBlock:(()->())?) {
    DataEnv.getEduUserToken { (sccess, error) -> () in
      if sccess {
        let opacUrl     = "http://opac.hfut.edu.cn:8080/reader/hwthau.php"
        let bookListUrl = "http://opac.hfut.edu.cn:8080/reader/redr_info.php"
        request(.GET, opacUrl, parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
          .response { (requst, response, data, error) -> Void in
            print(response)
            if error == nil {
              let header = [
                "Cookie":response?.allHeaderFields["Set-Cookie"] as? String ?? ""
              ]
              request(.GET, bookListUrl, parameters: nil, encoding: .URL, headers: header)
                .response(completionHandler: { (requst, response, data, error) -> Void in
                  print(requst)
                  print(response)
                  self.parseResult(data)
                })
            } else {
              onNetErrorBlock?()
            }
        }
      }
    }
  }
  
  private func parseResult(data:NSData?) {
    if let data = data, htmlString = NSString(data:data, encoding: NSUTF8StringEncoding) as? String {
      print(htmlString)
    }
  }
}