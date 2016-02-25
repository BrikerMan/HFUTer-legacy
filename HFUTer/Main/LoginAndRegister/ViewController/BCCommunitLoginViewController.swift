//
//  BCCommunitLoginViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/17.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCCommunitLoginViewController: EEBaseViewController {
  
  @IBOutlet weak var userIDField: BCTextField!
  @IBOutlet weak var passwordField: BCTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "登录社区"
    userIDField.updateTintColor()
    passwordField.updateTintColor()
    if DataEnv.eduUser.isLogin {
      userIDField.text = DataEnv.eduUser.username
    }
  }
  
  
  @IBAction func onLoginButtonPressed(sender: AnyObject) {
    let user = ComUser()
    user.username = userIDField.text!
    user.password = passwordField.text!
    BCCommunityUserLoginRequest.login(user.username, password: user.password,
      onSuccessBlock: { (response) -> () in
        if let data = response["data"] as? NSDictionary, let avatar = data["image"] as? String{
          user.avatar = avatar
        }
        DataEnv.saveComUser(user)
        APService.setTags(["push"], alias: DataEnv.eduUser.username, callbackSelector: nil, object: nil)
        Hud.showMassage("登录成功")
        self.pop()
      }, onFailedBlock: { (reason) -> () in
        Hud.showError(reason)
      }) { () -> () in
        Hud.showMassage("网络错误，请稍后再试")
    }
  }
  
  
  @IBAction func onRegisterButtonPressed(sender: AnyObject) {
    if DataEnv.eduUser.isLogin {
      let vc = BCCommunityRegisterViewController(nibName:"BCCommunityRegisterViewController",bundle:nil)
      self.pushToViewController(vc)
    } else {
      Hud.showMassage("请先登录教务系统")
      RootVC.showLoginToSchoolVC()
    }
  }
  
  
  
  func registerForNotification() {
    self.navigationController?.popToRootViewControllerAnimated(true)
    Hud.showMassage("社区注册成功")
//    APService.registerForRemoteNotificationTypes(1|2|3, categories: nil)
  }
}
