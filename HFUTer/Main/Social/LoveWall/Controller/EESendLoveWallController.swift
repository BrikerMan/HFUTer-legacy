//
//  EESendLoveWallController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/4.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class EESendLoveWallController: EEBaseFormViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initUI()
  }
  
  private func sedLoveWallMassage() {
    let values = form.values()
    if !isEurekaValueForKeyExist(values, rowName: "content") {
      Hud.showError("请输入表白内容")
      return
    }
    
    let url = getComURL("api/confession/createConfession")
    
    let param:[String:AnyObject] = [
      "content":values["content"] as? String ?? "",
      "anonymous":values["anonymous"] as? Bool ?? true,
    ]
    
    Hud.showLoading("正在发送")
    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: param,
      onFinishedBlock: { (response) -> Void in
        Hud.showMassage("发送成功")
        self.pop()
      }, onFailedBlock: { (reason) -> Void in
        Hud.showError(reason)
      }) { () -> Void in
        Hud.showError(NetErrorWarning)
    }
  }
  
  
  private func initUI() {
    self.tableView?.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)
    
    form
      +++ Section("填写表白内容")
      
      <<< TextAreaRow("content") {
        $0.placeholder = "表白内容"
      }
      
      <<< SwitchRow("anonymous"){
        $0.title = "匿名"
      }
      
      +++ Section()
      <<< ButtonRow("send"){
        $0.title = "发送"
        $0.onCellSelection({ (cell, row) -> () in
          self.sedLoveWallMassage()
        })
    }
  }
}
