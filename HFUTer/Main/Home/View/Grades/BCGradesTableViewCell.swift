//
//  BCGradesTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/9/13.
//  Copyright (c) 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCGradesTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var codeLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var score2Label: UILabel!
  @IBOutlet weak var creditLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setupWithModel(model:GradeModel) {
    nameLabel.text = model.name
    codeLabel.text = model.code
    scoreLabel.text = model.score
    score2Label.text = model.score2
    creditLabel.text = model.credit
  }
}
