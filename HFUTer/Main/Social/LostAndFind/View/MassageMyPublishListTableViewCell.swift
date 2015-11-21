//
//  MassageMyPublishListTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/19.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol MassageMyPublishListTableViewCellDelegate {
  func onEndButtonPress(cellIndex:Int)
  func MassageLostListImagesPressed(imageLinks:[String],index:Int)
}


class MassageMyPublishListTableViewCell: UITableViewCell {
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var lostAndFindImageView: UIImageView!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var imagesView: UIView!
  @IBOutlet weak var imageView1: EEImageView!
  @IBOutlet weak var imageView2: EEImageView!
  @IBOutlet weak var imageView3: EEImageView!
  @IBOutlet weak var endButton: UIButton!
  
  private var cellIndex = 0
  private var imageLinks:[String]!
  private var imagesViewList:[EEImageView]!
  
  var delegate:MassageMyPublishListTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    imagesViewList = [imageView1,imageView2,imageView3]
    
    lostAndFindImageView.hidden = true
    
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
  
  
  func setupModel(model:BCMassageMyPublishModel,index:Int) {
    self.cellIndex = index
    for view in imagesViewList {
      view.hidden = true
    }
    
    contentLabel.text = model.content
    timeLabel.text = Utilities.getTimeString(model.date)
    for i in 0..<model.pic.count {
      let imageView = imagesViewList[i]
      imageView.loadThumbnail(model.pic[i])
      imageView.hidden = false
    }
    
    if model.statue == 0 {
      endButton.setTitle("标记结束", forState: UIControlState.Normal)
      endButton.enabled = true
    } else {
      endButton.setTitle("已结束", forState: UIControlState.Normal)
      endButton.enabled = false
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
  
  static func getHeightForModel(model:BCMassageMyPublishModel) -> CGFloat{
    let titleHight = Utilities.getLabelHeightWithFontSize(model.content, font: UIFont.systemFontOfSize(12), width: ScreenWidth-20)
    if model.pic.count == 0 {
      return 93 + titleHight
    } else {
      return 183 + titleHight
    }
  }
  
  @IBAction func onEndThisButtonPressed(sender: AnyObject) {
    delegate?.onEndButtonPress(self.cellIndex)
  }
}
