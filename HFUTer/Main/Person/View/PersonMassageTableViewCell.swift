//
//  PersonMassageTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class PersonMassageTableViewCell: UITableViewCell {
  
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var avatarView: EEImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var massageLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    mainView.layer.cornerRadius = 5
    avatarView.layer.cornerRadius = avatarView.frame.size.height/2
    self.backgroundColor = UIColor.clearColor()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    
  }
  
  func setupWithModel(model:EECommunityMassageModel) {
    avatarView.loadAvatar(model.sImage)
    nameLabel.text = model.name
    massageLabel.text = model.message
    timeLabel.text = Utilities.getTimeStringFromTimeStamp(model.date_int)
  }
  
  class func getHeightFormModel(model:EECommunityMassageModel) -> CGFloat {
    let height = Utilities.getLabelHeightWithFontSize(model.message, font: UIFont.systemFontOfSize(12), width: ScreenWidth - 72)
    return height + 85
  }
  
}
