//
//  BCMyMassagesTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCMyMassagesTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var avatarView: EEImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var massageLabel: UILabel!
  
  private var index = 0
  
  override func awakeFromNib() {
    super.awakeFromNib()
    avatarView.layer.cornerRadius = avatarView.frame.size.height/2
  }
  
  func setupWithModel(model:BCMyMassageModel,index:Int) {
    avatarView.loadAvatar(model.sImage)
    nameLabel.text = model.name
    timeLabel.text = Utilities.getTimeString(model.date)
    massageLabel.text = model.message
  }
  
  static func getHeightForModel(model:BCMyMassageModel) -> CGFloat{
    let titleHight = Utilities.getLabelHeightWithFontSize(model.message, font: UIFont.systemFontOfSize(14), width: ScreenWidth-25)
    return 75 + titleHight
  }
}
