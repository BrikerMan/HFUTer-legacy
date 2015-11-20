//
//  HDBaseFlatTextField.swift
//  Hande
//
//  Created by Eliyar Eziz on 15/11/17.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

@IBDesignable
class HDBaseFlatTextField: UITextField {

  private let buttomLine = CAShapeLayer()

  @IBInspectable var bottomLineColor = UIColor.whiteColor() {
    didSet {
      buttomLine.backgroundColor = bottomLineColor.CGColor
    }
  }

  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    buttomLine.frame = CGRectMake(0, rect.size.height-1, rect.size.width, 1)
    buttomLine.backgroundColor = bottomLineColor.CGColor
    self.layer.addSublayer(buttomLine)
  }

}
