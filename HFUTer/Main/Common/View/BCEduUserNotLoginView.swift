//
//  BCEduUserNotLoginView.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/7.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCEduUserNotLoginView: EEXibView{
  
  @IBOutlet weak var loginButton: BCBaseButton!
  
  override func initFromXib() {
    super.initFromXib()
    loginButton.layer.borderColor = Color.primaryTintColor.CGColor
  }
  
  @IBAction func onLoginButtonPressed(sender: AnyObject) {
    RootVC.showLoginToSchoolVC()
  }
  
}
