//
//  MassageMoreActionView.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/15.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol MassageMoreActionViewDelegate {
  func didSelectAtIndex(index:Int)
}

class MassageMoreActionView: UIView {

  var delegate:MassageMoreActionViewDelegate?
  var height  = 0
  
  private var buttonList = [String]()
  
  private var buttonHeight = 40
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)
  }
  
  /**
   初始化
   
   - parameter forStyle: 状态，0失物招领，1表白墙
   */
  convenience init(forStyle:Int) {
    self.init()
    self.backgroundColor = Color.primaryTintColor.light()
    if forStyle == 0 {
      buttonList = ["我丢了东西","我捡了东西","我的发布"]
      
    } else if forStyle == 1 {
      buttonList = ["发表白","我的发布"]
    }
    height = buttonList.count * buttonHeight
    initUI()
  }
  
  private func initUI() {
    for i in 0..<buttonList.count {
      let button = UIButton()
      button.tag = i
      button.setTitle(buttonList[i], forState: .Normal)
      button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
      button.addTarget(self, action: "onButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
      self.addSubview(button)
      
      button.snp_makeConstraints(closure: { (make) -> Void in
        make.top.equalTo(self.snp_top).offset(i*buttonHeight)
        make.left.equalTo(self.snp_left)
        make.right.equalTo(self.snp_right)
        make.height.equalTo(buttonHeight)
      })
    }
  }
  
  func onButtonPressed(sender:AnyObject?) {
    if let sender = sender as? UIButton {
      delegate?.didSelectAtIndex(sender.tag)
    }
  }
  
  func changeTintColor() {
    self.backgroundColor = Color.primaryTintColor.light()
  }
}
