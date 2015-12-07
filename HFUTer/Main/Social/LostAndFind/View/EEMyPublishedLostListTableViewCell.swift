//
//  EEMyPublishedLostListTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/3.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class EEMyPublishedLostListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var actionButton: UIButton!
  
  private var model:EECommunityMyPublishesLostAndFoundModel!
  private var index:Int!
  
  var clickedBlock:((index:Int)->())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    mainView.layer.cornerRadius = 5
  }
  
  func setupWithModel(model:EECommunityMyPublishesLostAndFoundModel, index:Int) {
    self.model = model
    self.index = index
    dateLabel.text = Utilities.getTimeStringFromTimeStamp(model.date_int)
    titleLabel.text = model.content
    actionButton.enabled = (model.statue == 0)
    if model.statue == 0 {
      actionButton.setFAText(prefixText: "", icon: .FASquareO , postfixText:  " 标记结束", size: nil, forState: UIControlState.Normal)
    } else {
      actionButton.setFAText(prefixText: "", icon: .FACheckSquareO , postfixText:  " 已结束", size: nil, forState: UIControlState.Normal)
    }
  }
  
  @IBAction func onActionButtonPressed(sender: AnyObject) {
    clickedBlock?(index:self.index)
  }
  class func heightForModel(model:EECommunityMyPublishesLostAndFoundModel) -> CGFloat {
    let height = Utilities.getLabelHeightWithFontSize(model.content, font: UIFont.systemFontOfSize(14), width: ScreenWidth-32)
    return height + 80
  }
}
