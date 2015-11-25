//
//  BCCourseFeeTableViewHeader.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/9/16.
//  Copyright (c) 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCCourseFeeTableViewHeader: EEXibView {

  
  @IBOutlet weak var seperator: UIView!
  @IBOutlet weak var scheduleNameLabel: UILabel!
  @IBOutlet weak var semesterDetailLabel: UILabel!
  
  override func initFromXib() {
    super.initFromXib()
    self.seperator.backgroundColor = Color.primaryTintColor
  }

  func setupTitle(title:String,detail:String) {
    scheduleNameLabel.text = title
    semesterDetailLabel.text = detail
  }
  
  func changeTintColor() {
    self.seperator.backgroundColor = Color.primaryTintColor
  }
}
