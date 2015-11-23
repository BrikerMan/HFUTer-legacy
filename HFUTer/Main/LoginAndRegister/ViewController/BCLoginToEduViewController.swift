//
//  BCLoginViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/9/9.
//  Copyright (c) 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
//import Crashlytics

class BCLoginToEduViewController: EEBaseViewController {
  
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var schoolYardChoose: UISegmentedControl!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  
  @IBOutlet weak var logoImage: UIImageView!
  @IBOutlet weak var loginView: UIView!
  
  private var isLoginRequestGoing = false
  private var isViewSlided = false
  
  //  private var hud:WSProgressHUD!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navBar.hidden = true
    loginButton.layer.cornerRadius = 5
    cancelButton.layer.cornerRadius = 5
    self.loginView.backgroundColor = Color.primaryTintColor
  }
  
  
  @IBAction func onLoginButtonPress(sender: AnyObject) {
    if usernameField.text != "" && passwordField.text != "" {
      startLoginRequest()
    } else {
      Hud.showError("请填写信息")
    }
    self.view.endEditing(true)
  }
  
  @IBAction func onCancelButtonPress(sender: AnyObject) {
    super.pop()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func onHelpButtonPressed(sender: AnyObject) {
    //    let vc = BCHelpViewController(nibName:"BCHelpViewController",bundle:nil)
    //    self.pushToViewController(vc)
  }
  
  func startLoginRequest() {
    if !isLoginRequestGoing {
      Hud.showLoadingWithMask("正在登录")
      isLoginRequestGoing = true
      let user = EduUser()
      user.username = usernameField.text!
      user.password = passwordField.text!
      if schoolYardChoose.selectedSegmentIndex == 0 {
        user.schoolYard = "HF"
      } else {
        user.schoolYard = "XC"
      }
      
      BCLoginToEduRequest.login(user,
        onLoginBlock: { () -> Void in
          Hud.dismiss()
          user.isLogin = true
          user.showWeekEnd = false
          DataEnv.saveEduUser(user)
          self.isLoginRequestGoing = false
          self.getUserDetail(user)
          //
          //          Answers.logLoginWithMethod(user.schoolYard,
          //            success: true,
          //            customAttributes: [:])
        }, onWrongPassWordBlock: { () -> Void in
          //          Answers.logLoginWithMethod(user.schoolYard,
          //            success: false,
          //            customAttributes: [:])
          Hud.showError("帐号或密码错误")
          self.isLoginRequestGoing = false
        }) { () -> Void in
          Hud.showError("网络错误")
          self.isLoginRequestGoing = false
      }
    }
  }
  
  
  //TODO: 处理登录后的
  func getUserDetail(user: EduUser) {
    Hud.showLoadingWithMask("正在获取用户信息")
    BCGetUserDetailFromEduRequest.get(user, onSuccessGetBlock: { () -> Void in
      Hud.dismiss()
      DataEnv.saveEduUser(user)
      self.dismissViewControllerAnimated(true, completion: nil)
      NotifCenter.postNotificationName(BCUserLoginNotification, object: nil)
      
      }, onParseFailBlock: { () -> Void in
        Hud.dismiss()
        self.dismissViewControllerAnimated(true, completion: nil)
        NotifCenter.postNotificationName(BCUserLoginNotification, object: nil)
        
      }) { () -> Void in
        Hud.dismiss()
        self.dismissViewControllerAnimated(true, completion: nil)
        NotifCenter.postNotificationName(BCUserLoginNotification, object: nil)
        
    }
  }
  
}
