//
//  BCMassageLoveTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/24.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class BCMassageLoveTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var avatarView: EEImageView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var colorfulBackView: UIView!
  @IBOutlet weak var colorfulBaclView2: UIView!
  @IBOutlet weak var likeCount: UILabel!
  @IBOutlet weak var commentCount: UILabel!
  
  //  @IBOutlet weak var button1: BCImageButtonView!
  //  @IBOutlet weak var button2: BCImageButtonView!
  
  private var index = 0
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = UIColor.clearColor()
    self.contentView.backgroundColor = UIColor.clearColor()
    self.mainView.backgroundColor = UIColor.whiteColor()
    mainView.layer.cornerRadius = 5
    avatarView.layer.cornerRadius = avatarView.frame.size.height/2
    //    button1.setupIconAndTitle("loveWall-like", title: "赞",index:self.index )
    //    button2.setupIconAndTitle("loveWall-comment", title: "评论",index:self.index)
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setupWithModel(model:BCMassageLoveWallModel,index:Int) {
    self.index = index
    avatarView.loadAvatar(model.image)
    if model.name == "" {
      nameLabel.text = "匿名"
    } else {
      nameLabel.text = model.name
    }
    
    timeLabel.text =  Utilities.getTimeString(model.date)
    contentLabel.text = model.content
    
    commentCount.setFAText(prefixText: "", icon: .FACommentsO , postfixText: " \(model.commentCount)", size: 12)
    
    if model.good {
      likeCount.setFAText(prefixText: "", icon: .FAHeart , postfixText: " \(model.goodCount)", size: 12)
    } else {
      likeCount.setFAText(prefixText: "", icon: .FAHeartO , postfixText: " \(model.goodCount)", size: 12)
      
    }
    
    (colorfulBackView.backgroundColor,colorfulBaclView2.backgroundColor) =
      (Color.getLoveWallColors(model.color),Color.getLoveWallColors(model.color))
  }
  
  
  class func getHeightForModel(model:BCMassageLoveWallModel) -> CGFloat{
    let contentHeight = Utilities.getLabelHeightWithFontSize(model.content, font: UIFont.systemFontOfSize(16), width: ScreenWidth-50)
    return contentHeight + 101.0
  }
  
}
