//
//  HDBaseFlatButton.swift
//  Hande
//
//  Created by Eliyar Eziz on 15/11/17.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HDBaseFlatButton: UIButton {

  @IBInspectable var bottomLineColor = UIColor.whiteColor() {
    didSet {
      self.layer.borderColor = bottomLineColor.CGColor
    }
  }

  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    self.layer.cornerRadius = 3
    self.layer.borderColor  = bottomLineColor.CGColor
    self.layer.borderWidth  = 1
  }

}
