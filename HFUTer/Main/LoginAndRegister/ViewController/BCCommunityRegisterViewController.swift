//
//  BCCommunityRegisterViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/18.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCCommunityRegisterViewController: EEBaseViewController {
  
  @IBOutlet weak var passwordLabel: BCTextField!
  @IBOutlet weak var passwordConfermLabel: BCTextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "创建社区用户"
    passwordLabel.updateTintColor()
    passwordConfermLabel.updateTintColor()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  @IBAction func onRegisterButtonPressed(sender: AnyObject) {
    if passwordLabel.text?.characters.count < 6 {
      Hud.showMassage("请输入6位以上密码")
      return
    }
    
    if passwordLabel.text != passwordConfermLabel.text {
      Hud.showMassage("两次输入密码不同")
      return
    }
    let data = DataManager.encodeUserData(DataEnv.eduUser, password: passwordLabel.text!)
    Hud.showLoadingWithMask("正在注册")
    BCCommunityUserRegisterRequest.register(data, onSuccessBlock: { () -> () in
        Hud.showMassage("注册成功")
      }, onFailedBlock: { (reason) in
        Hud.showError(reason)
      }) { () -> () in
        Hud.showMassage("网络错误，请稍后再试")
    }
  }
}
