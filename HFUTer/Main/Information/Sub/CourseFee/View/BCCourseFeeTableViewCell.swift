//
//  BCCourseFeeTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/9/15.
//  Copyright (c) 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCCourseFeeTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var creditLabel: UILabel!
  @IBOutlet weak var feeLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setupWithModel(model:CourseFeeModel) {
    nameLabel.text = model.name
    creditLabel.text = model.credit
    feeLabel.text = model.fee
  }
  
}
