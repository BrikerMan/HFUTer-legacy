//
//  BCLeaveContectInfoView.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/15.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol BCLeaveContectInfoViewDelegate {
  func onSendButtonPressed(phoneNumber:String,contactInfo:String)
}

class BCLeaveContectInfoView: EEXibView {

  @IBOutlet weak var phoneNumberField: BCTextField!
  @IBOutlet weak var contactInfoFiled: BCTextField!
  @IBOutlet weak var sendButton: BCBaseButton!

  var delegate:BCLeaveContectInfoViewDelegate?
  
  override func initFromXib() {
    super.initFromXib()
    self.view?.layer.cornerRadius = 5
    phoneNumberField.updateTintColor()
    contactInfoFiled.updateTintColor()
  }
  
  func changeTintColor() {
    phoneNumberField.updateTintColor()
    contactInfoFiled.updateTintColor()
    sendButton.updateTintColor()
  }
  
  func clearText() {
    phoneNumberField.text = ""
    contactInfoFiled.text = ""
  }
  
  @IBAction func onSendButtonPressed(sender: AnyObject) {
    if phoneNumberField.text == "" {
      Hud.showMassage("请留下手机号码")
      return
    }
    if contactInfoFiled.text == "" {
      Hud.showMassage("请填写详情")
      return
    }
    
    if contactInfoFiled.text?.characters.count < 10 {
      Hud.showMassage("详情最少十个字")
      return
    }
    delegate?.onSendButtonPressed(phoneNumberField.text!, contactInfo: contactInfoFiled.text!)
  }
}
