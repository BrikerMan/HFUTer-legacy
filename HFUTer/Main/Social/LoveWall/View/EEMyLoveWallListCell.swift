//
//  EEMyLoveWallListCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/7.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class EEMyLoveWallListCell: UITableViewCell {
  
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var commentCountLabel: UILabel!
  @IBOutlet weak var likeCountLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var actionButton: UIButton!
  
  var actionBlock:(()->())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    mainView.layer.cornerRadius = 5
  }
  
  
  func setupWithModel(model:EECommunityLoveWallModel) {
    timeLabel.text = Utilities.getTimeStringFromTimeStamp(model.date_int)
    
    contentLabel.text = model.content
    commentCountLabel.setFAText(prefixText: "", icon: .FACommentsO , postfixText: " \(model.commentCount)", size: 12)
    likeCountLabel.setFAText(prefixText: "", icon: .FAHeartO , postfixText: " \(model.favoriteCount)", size: 12)
    
    actionButton.setFAText(prefixText: "", icon: .FATrashO, postfixText: " 删除", size: nil, forState: .Normal)
  }
  
  @IBAction func onActionButtonPressed(sender: AnyObject) {
    let alartView = UIAlertView()
    alartView.addButtonWithTitle("删除")
    alartView.addButtonWithTitle("取消")
    alartView.title = "确认删除？"
    alartView.message = "删除后将不再在表白墙内显示，一旦删除该表白赞和评论同时被删除并不可恢复。"
    alartView.delegate = self
    alartView.show()
  }
  
  class func heightForModel(model:EECommunityLoveWallModel) -> CGFloat{
    let height = Utilities.getLabelHeightWithFontSize(model.content, font: UIFont.systemFontOfSize(15), width: ScreenWidth - 32)
    return 92 + height
  }
}


extension EEMyLoveWallListCell:UIAlertViewDelegate {
  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == 0 {
      actionBlock?()
    }
  }
}
