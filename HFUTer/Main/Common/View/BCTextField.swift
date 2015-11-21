//
//  BCTextField.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/22.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

@IBDesignable
class BCTextField: UITextField {
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    let buttomLine:UIBezierPath = UIBezierPath(rect:CGRectMake(0, rect.size.height-0.5, rect.size.width, 0.5))
    UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7 ).set()
    buttomLine.stroke()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  func updateTintColor() {
    let view = UIView()
    view.backgroundColor =  Color.primaryTintColor.light()
    self.addSubview(view)
    
    view.snp_makeConstraints { (make) -> Void in
      make.left.equalTo(self.snp_left)
      make.right.equalTo(self.snp_right)
      make.height.equalTo(1)
      make.bottom.equalTo(self.snp_bottom)
    }
  }
}