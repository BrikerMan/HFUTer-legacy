//
//  BCLoginToEduViewController.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCLoginToEduViewController: EEBaseViewController {
  
  var loginBlock:(()->())?
  
  //IB Referece
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var schoolYardChoose: UISegmentedControl!
  
  //状态表示
  private var isLoginRequestGoing = false
  
  // MARK:- 生命周期
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navBar.hidden = true
  }
  
  // MARK:- 按钮动作
  @IBAction func loginButtonPressed(sender: AnyObject) {
    if !isLoginRequestGoing {
      isLoginRequestGoing = true
      beganLoginRequest()
    }
  }
  
  
  // MARK:- 网络请求
  private func beganLoginRequest() {
    let user           = EduUser()
    user.username      = usernameField.text!
    user.password      = passwordField.text!
    if schoolYardChoose.selectedSegmentIndex == 0 {
      user.schoolYard = "HF"
    } else {
      user.schoolYard = "XC"
    }
    
    Hud.showLoadingWithMask("正在登录")
    BCLoginToEduRequest.login(user,
      onLoginBlock: { () -> Void in
        user.hasGetToken = true
        DataEnv.saveEduUser(user)
        Hud.dismiss()
        self.pop()
        self.dismissViewControllerAnimated(true, completion: nil)
        self.loginBlock?()
        NSNotificationCenter.defaultCenter().postNotificationName(BCUserLoginNotification, object: nil, userInfo: nil)
        self.isLoginRequestGoing = false
      }, onWrongPassWordBlock: { () -> Void in
        self.isLoginRequestGoing = false
      }, onFailedBlock: { () -> Void in
        self.isLoginRequestGoing = false
    })
  }
}
