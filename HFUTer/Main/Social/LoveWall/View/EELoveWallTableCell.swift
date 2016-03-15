//
//  EELoveWallTableCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 16/3/13.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class EELoveWallTableCell: UITableViewCell {
    
    var index:Int = 0
    var model: EECommunityLoveWallModel!

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var avatarImageView: EEImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 3
        avatarImageView.layer.cornerRadius = 15
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithModel(model: EECommunityLoveWallModel, index: Int) {
        self.index = index
        self.model = model
        
        avatarImageView.loadAvatar(model.image)
        
        if model.name == "" {
            nickNameLabel.text = "匿名"
        } else {
            nickNameLabel.text = model.name
        }
        
        timeLabel.text =  Utilities.getTimeStringFromTimeStamp(model.date_int)
        
        infoLabel.text = model.content
        
        if model.color == 0 {
            genderImageView.image = UIImage(named: "community_user_gender_man")
        } else {
            genderImageView.image = UIImage(named: "community_user_gender_woman")
        }
        
        commentCount.text = "\(model.commentCount)"
        likeCount.text = "\(model.favoriteCount)"
        
    }
    
    class func getHeightForModel(model:EECommunityLoveWallModel) -> CGFloat{
        let contentHeight = Utilities.getLabelHeightWithFontSize(model.content, font: UIFont.systemFontOfSize(14), width: ScreenWidth-40)
        return contentHeight + 101.0
    }
    
}
