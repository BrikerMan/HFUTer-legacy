//
//  BCClassDetailTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/9/16.
//  Copyright (c) 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCClassDetailTableViewCell: UITableViewCell {
  
  @IBOutlet weak var serialLabel: UILabel!
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setupWithModel(model:StudentModel) {
    serialLabel.text = model.serial
    idLabel.text = model.id
    nameLabel.text = model.name
  }
  
}
