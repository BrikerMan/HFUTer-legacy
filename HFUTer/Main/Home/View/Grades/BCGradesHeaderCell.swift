//
//  BCGradesHeaderCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/25.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCGradesHeaderCell: UITableViewCell {
  
  @IBOutlet weak var infoCell: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setAllGrades(model:SemesterModel) {
    let gpa = NSString(format:"%.2f", model.gpa)
    let avarage = NSString(format:"%.2f", model.average)
    infoCell.text = "总绩点：\(gpa)、总平均分：\(avarage)、总公选学分：\(model.gongxuanXuefen)"
  }
}
