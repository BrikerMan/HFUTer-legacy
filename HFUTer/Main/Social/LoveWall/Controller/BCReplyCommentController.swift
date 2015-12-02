//
//  BCReplyCommentController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/1.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

@objc protocol BCReplyCommentControllerDelegate {
  func replyCommentControllerDidReply(commend:String,anonymously:Bool,to:Int)
  optional func replyCommentControllerDidCancel()
}

class BCReplyCommentController: EEBaseViewController {
  
  var delegate:BCReplyCommentControllerDelegate?
  var to = 0
  
  @IBOutlet weak var navView: UIView!
  @IBOutlet weak var anonymouslySwitch: UISwitch!
  @IBOutlet weak var textView: EETextView!
  //底部约束
  @IBOutlet weak var textViewBottom: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navBar.hidden = true
    self.navView.backgroundColor = Color.primaryTintColor
    NotifCenter.addObserver(self, selector: "keyBoardWillShowOrHideAnimation:", name: UIKeyboardWillShowNotification, object: nil)
    NotifCenter.addObserver(self, selector: "keyBoardWillShowOrHideAnimation:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  
  //MARK:- 动画
  @objc private func keyBoardWillShowOrHideAnimation(notification:NSNotification) {
    if let userInfo = notification.userInfo {
      if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
        self.textViewBottom.constant = keyboardHeight
        UIView.animateWithDuration(0.25, animations: { () -> Void in
          self.view.layoutIfNeeded()
        })
      }
    }
  }
  
  @IBAction func onCancelButtonPressed(sender: AnyObject) {
    self.view.endEditing(true)
    self.dismissViewControllerAnimated(true, completion: {
      self.delegate?.replyCommentControllerDidCancel?()
    })
  }
  
  @IBAction func onSendButtonPressed(sender: AnyObject) {
    if self.textView.text == "" {
      Hud.showError("请输入评论内容")
      return
    }
    self.view.endEditing(true)
    self.dismissViewControllerAnimated(true, completion: { Void in
      self.delegate?.replyCommentControllerDidReply(self.textView.text, anonymously: self.anonymouslySwitch.on, to: self.to)
    })
  }
}
