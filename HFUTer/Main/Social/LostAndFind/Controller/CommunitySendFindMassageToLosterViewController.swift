//
//  CommunitySendFindMassageToLosterViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/26.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class CommunitySendFindMassageToLosterViewController: EEBaseFormViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "发送消息给同学"
    initForm()
  }
  
  private func sendMassageToStudent() {
    let values = form.values()
    if !isEurekaValueForKeyExist(values, rowName: "id") {
      Hud.showError("请输入对方学号")
      return
    }
    
    if !isEurekaValueForKeyExist(values, rowName: "phone") {
      Hud.showError("请输入手机号")
      return
    }
    
    var massage = "我是\(DataEnv.eduUser.name)，学号\(DataEnv.eduUser.username)，我捡到了你的东西，我的电话号码是："
    if let phone = values["phone"] as? String {
      massage = massage + phone
    }
    
    if let mass = values["massage"] as? String {
      massage = massage + "。" + mass
    }
    
    let url = getComURL("api/user/sendMessage")
    
    let param:[String:AnyObject] = [
      "sid":values["id"] as? Int ?? 0,
      "message":massage,
      "mass":values["multiSend"] as? Bool ?? false,
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
  
  private func initForm() {
    self.tableView?.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)
    
    form = Section(header:"请输入要联系同学的学号",footer:"输入要发送的消息。消息务必包含你的姓名、学号和联系方式，以保证信息的真实性。")
      
      <<< IntRow("id"){
        $0.title = nil
        $0.placeholder = "学号"
        }.cellSetup({ (cell, row) -> () in
          row.formatter = nil
        })
      
      
      +++ Section("我是\(DataEnv.eduUser.name)，学号\(DataEnv.eduUser.username)，我捡到了你的东西，我的电话号码是：")
      
      <<< PhoneRow("phone"){
        $0.title = nil
        $0.placeholder = "我的手机号"
      }
      <<< TextAreaRow("massage") {
        $0.placeholder = "备注"
      }
      
      +++ Section("如果此同学未用过该软件或为开启推送功能，则你可以选择群发给该学号学号上下各十名同学。如果其中有同学使用HFUTer并开启推送功能则会收到此消息。")
      <<< SwitchRow("multiSend"){
        $0.title = "群发"
      }
      
      
      +++ Section()
      <<< ButtonRow("send"){
        $0.title = "发送"
        }
        .onCellSelection({ (cell, row) -> () in
          self.sendMassageToStudent()
        })
  }
}
