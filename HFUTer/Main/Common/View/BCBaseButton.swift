//
//  BCBaseButton.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/22.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCBaseButton: UIButton {

  override func drawRect(rect: CGRect) {
    self.layer.cornerRadius = 3
    self.layer.borderColor = UIColor ( red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0 ).CGColor
    self.layer.borderWidth = 1
  }
  
  func updateTintColor() {
    self.backgroundColor = Color.primaryTintColor
  }
}
