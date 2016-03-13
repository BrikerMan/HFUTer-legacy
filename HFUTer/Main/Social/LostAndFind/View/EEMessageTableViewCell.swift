//
//  EEMessageTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 16/3/12.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol EEMessageTableViewCellDelegate {
    func onReplyButtonPress(index:Int)
    func MassageLostListImagesPressed(imageLinks:[String],index:Int)
}

class EEMessageTableViewCell: UITableViewCell {
    
    var delegate: EEMessageTableViewCellDelegate?
    
    var index:Int!
    var imageLinks:[String] = []
    
    private var imagesViewList:[EEImageView]!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var avatarImage: EEImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var imagesView: UIView!
    
    @IBOutlet weak var imageView1: EEImageView!
    @IBOutlet weak var imageView2: EEImageView!
    @IBOutlet weak var imageView3: EEImageView!
    
    @IBOutlet weak var objectName: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var timeInfoLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var lostAndFoundImage: UIImageView!
    
    @IBOutlet weak var contactButton: UIButton!
    
    
    @IBOutlet weak var seperator1Height: NSLayoutConstraint!
    @IBOutlet weak var seperator2Height: NSLayoutConstraint!
    @IBOutlet weak var seperator3Height: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contactButton.layer.cornerRadius = 3
        contactButton.backgroundColor = Color.primaryTintColor
        mainView.layer.cornerRadius = 3
        avatarImage.layer.cornerRadius = 3
        
        imagesViewList = [imageView1,imageView2,imageView3]
        
        for i in 0..<3 {
            let tap = UITapGestureRecognizer(target: self, action: Selector("onImageTapped\(i):"))
            imagesViewList[i].addGestureRecognizer(tap)
            imagesViewList[i].userInteractionEnabled = true
            imagesViewList[i].hidden = true
        }
        
        seperator1Height.constant = 0.5
        seperator2Height.constant = 0.5
        seperator3Height.constant = 0.5
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func onImageTapped0(sender:AnyObject?) {
        delegate?.MassageLostListImagesPressed(self.imageLinks,index:0)
    }
    func onImageTapped1(sender:AnyObject?) {
        delegate?.MassageLostListImagesPressed(self.imageLinks,index:1)
    }
    func onImageTapped2(sender:AnyObject?) {
        delegate?.MassageLostListImagesPressed(self.imageLinks,index:2)
    }
    
    
    @IBAction func onReplyButtonPress(sender: AnyObject) {
        delegate?.onReplyButtonPress(self.index)
    }
    
    
    func setModel(model:BCLostAndFoundModel,index:Int) {
        self.index = index
        for view in imagesViewList {
            view.hidden = true
        }
        
        if model.name == "" {
            nickNameLabel.text = "匿名"
        } else {
            nickNameLabel.text = model.name
        }
        
        if model.type == 0 {
            lostAndFoundImage.image = UIImage(named: "Community_Lost")
        } else {
            lostAndFoundImage.image = UIImage(named: "Community_Found")
        }
        
        infoLabel.text = model.content
        timeLabel.text = Utilities.getTimeStringFromTimeStamp(model.date_int)
        avatarImage.loadAvatar(model.image)
        
        timeInfoLabel.text = model.time
        objectName.text    = model.thing
        placeName.text     = model.place
        for i in 0..<model.pic.count {
            let imageView = imagesViewList[i]
            imageView.loadThumbnail(model.pic[i])
            imageView.hidden = false
        }
        
        if model.pic.count == 0 {
            imagesView.hidden = true
        } else {
            imagesView.hidden = false
            
        }
        self.imageLinks = model.pic
        self.layoutIfNeeded()
    }
    
    class func getHeight(forModel model:BCLostAndFoundModel) -> CGFloat {
        let height = Utilities.getLabelHeightWithFontSize(model.content, font: UIFont.systemFontOfSize(14), width: ScreenWidth-65)
        if model.pic.count == 0 {
            return 188 + height
        } else {
            return 188 + 105 + height
        }
    }
    
}
