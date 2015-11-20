//
//  BCGradeViewTableViewHeader.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/9/13.
//  Copyright (c) 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCGradeViewTableViewHeader: EEXibView {

  @IBOutlet weak var seperatorView: UIView!
  @IBOutlet weak var semesterNameLabel: UILabel!
  @IBOutlet weak var gpaLabel: UILabel!
  
  func setupWithSemester(model:SemesterModel) {
    semesterNameLabel.text = model.name
    let gpa = NSString(format:"%.4f", model.gpa)
    let avarage = NSString(format:"%.4f", model.average)
    gpaLabel.text = "绩点：\(gpa)、平均分：\(avarage)、公选学分：\(model.gongxuanXuefen)"
    
  }
  
  override func initFromXib() {
    super.initFromXib()
    seperatorView.backgroundColor = Color.primaryTintColor
  }
  
  func changeTintColor() {
    seperatorView.backgroundColor = Color.primaryTintColor
  }

}
