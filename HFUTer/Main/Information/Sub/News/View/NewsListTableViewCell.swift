//
//  NewsListTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/9/7.
//  Copyright (c) 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class NewsListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setModel(model:NewsListModel) {
    self.titleLabel.text = model.title
    self.timeLabel.text = model.date
    self.contentLabel.text = model.content
    if model.hasRead {
      self.titleLabel.alpha = 0.5
      self.timeLabel.alpha = 0.5
      self.contentLabel.alpha = 0.5
    } else {
      self.titleLabel.alpha = 1
      self.timeLabel.alpha = 1
      self.contentLabel.alpha = 1
    }
  }
  
  static func getHighForModel(model:NewsListModel) -> CGFloat {
    let titleHight = Utilities.getLabelHeightWithFontSize(model.title, font: UIFont.systemFontOfSize(14), width: ScreenWidth-43)
    let contentHight = Utilities.getLabelHeightWithFontSize(model.content, font: UIFont.systemFontOfSize(12), width: ScreenWidth-43)
    return (10 + titleHight + 22 + contentHight + 20)
  }
}
