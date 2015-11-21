//
//  BCLoveWallDetailTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/26.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCLoveWallDetailTableViewCell: UITableViewCell {
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var avatarView: EEImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.mainView.layer.cornerRadius = 5
    self.avatarView.layer.cornerRadius = self.avatarView.frame.size.height/2
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func setupWithModel(model:BCMassageCommentModel) {
    self.avatarView.loadAvatar(model.image)
    if model.name == "" {
      self.nameLabel.text = "匿名"
    } else {
      self.nameLabel.text = model.name
    }
    
    self.timeLabel.text = Utilities.getTimeString(model.date)
    self.contentLabel.text = model.content
  }
  
  
  static func getHightForModel(model:BCMassageCommentModel) -> CGFloat{
    let height = Utilities.getLabelHeightWithFontSize(model.content, font: UIFont.systemFontOfSize(14), width: ScreenWidth-100)
    return 80 + height
  }
  
}
