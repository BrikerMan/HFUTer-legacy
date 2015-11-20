//
//  BCXibView.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/7.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class EEXibView: UIView {
  
  var view:UIView?
  
  //MARK:- 生命周期
  deinit {
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initFromXib()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)!
    initFromXib()
  }
  
  //MARK:- UI相关
  func initFromXib(){
    let xibName = NSStringFromClass(self.classForCoder)
    let xibClassName = xibName.characters.split{$0 == "."}.map(String.init).last
    let view = NSBundle.mainBundle().loadNibNamed(xibClassName, owner: self, options: nil).first as! UIView
    view.frame = self.bounds
    view.translatesAutoresizingMaskIntoConstraints = true
    view.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
    self.addSubview(view)
    self.view = view
    
  }
  
  func funcChangeTintColor(notification:NSNotification?) {
    
  }
}