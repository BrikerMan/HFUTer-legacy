//
//  MassageLostTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/10.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

protocol MassageLostTableViewCellDelegate {
  func onReplyButtonPress(index:Int)
  func MassageLostListImagesPressed(imageLinks:[String],index:Int)
}

class MassageLostTableViewCell: UITableViewCell {
  

  @IBOutlet weak var avatarView: EEImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var imagesView: UIView!
  @IBOutlet weak var seperatorView: UIView!
  @IBOutlet weak var imageView1: EEImageView!
  @IBOutlet weak var imageView2: EEImageView!
  @IBOutlet weak var imageView3: EEImageView!
  @IBOutlet weak var backColorView: UIView!
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var contactButtonView: UIView!
  @IBOutlet weak var contactButton: UIButton!
  @IBOutlet weak var lostAndFindImage: UIImageView!
  
  
//  @IBOutlet weak var contactButton: UIButton!
  
  var delegate:MassageLostTableViewCellDelegate?
  
  private var index = 0
  private var imageLinks:[String]!
  private var imagesViewList:[EEImageView]!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    fixUI()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  private func fixUI() {
    self.backgroundColor = Color.primaryTintColor.ultraLight()
    self.contentView.backgroundColor = UIColor.clearColor()
    avatarView.layer.cornerRadius = avatarView.frame.size.height/2
    mainView.layer.cornerRadius = 5
    imagesViewList = [imageView1,imageView2,imageView3]

    contactButton.setFAText(prefixText: "", icon: .FAEnvelopeO , postfixText: " 联系", size: 14, forState: UIControlState.Normal)

    var i = 1
    for view in imagesViewList {
      let tap = UITapGestureRecognizer(target: self, action: Selector("onImageTapped\(i):"))
      view.addGestureRecognizer(tap)
      view.userInteractionEnabled = true
      i = i + 1
      view.hidden = true
    }
  }
  
  func onImageTapped1(sender:AnyObject?) {
    delegate?.MassageLostListImagesPressed(self.imageLinks,index:0)
  }
  func onImageTapped2(sender:AnyObject?) {
    delegate?.MassageLostListImagesPressed(self.imageLinks,index:1)
  }
  func onImageTapped3(sender:AnyObject?) {
    delegate?.MassageLostListImagesPressed(self.imageLinks,index:2)
  }
  @IBAction func onContactButtonPressed(sender: AnyObject) {
    delegate?.onReplyButtonPress(self.index)
  }
  func setModel(model:BCLostAndFoundModel,index:Int) {
    self.index = index
    for view in imagesViewList {
      view.hidden = true
    }
    
    if model.name == "" {
      nameLabel.text = "匿名"
    } else {
      nameLabel.text = model.name
    }
    
    if model.type == 0 {
      lostAndFindImage.image = UIImage(named: "Massage_Table_Lost.png")
    } else {
      lostAndFindImage.image = UIImage(named: "Massage_Table_Find.png")
    }
    
    infoLabel.text = model.content
    timeLabel.text = Utilities.getTimeStringForLoveWall(model.date)
    avatarView.loadAvatar(model.image)
    for i in 0..<model.pic.count {
      let imageView = imagesViewList[i]
      imageView.loadThumbnail(model.pic[i])
      imageView.hidden = false
    }
    
    if model.pic.count == 0 {
      imagesView.snp_updateConstraints(closure: { (make) -> Void in
        make.height.equalTo(0)
      })
      imagesView.hidden = true
      self.layoutIfNeeded()
    } else {
      imagesView.snp_updateConstraints(closure: { (make) -> Void in
        make.height.equalTo(90)
      })
      imagesView.hidden = false
      self.layoutIfNeeded()
    }
    
    self.imageLinks = model.pic
    
  }
  
  static func getHeightForModel(model:BCLostAndFoundModel) -> CGFloat{
    let titleHight = Utilities.getLabelHeightWithFontSize(model.content, font: UIFont.systemFontOfSize(12), width: ScreenWidth-130)
    var height:CGFloat = 0
    if model.pic.count == 0 {
      height = titleHight
    } else {
      height = 155 + titleHight
    }
    if height < 160 {
      return 160
    } else {
      return height
    }
  }
}
