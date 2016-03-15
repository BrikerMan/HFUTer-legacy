//
//  HFLoveWallHeaderCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 16/3/13.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFLoveWallHeaderCell: UITableViewCell {

    var model: EECommunityLoveWallModel!
    
    @IBOutlet weak var avatarImageView: EEImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 31/2
        avatarImageView.layer.borderWidth  = 1
        avatarImageView.layer.borderColor = Color.primaryTintColor.CGColor
        lineView.backgroundColor = Color.primaryTintColor
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithModel(model: EECommunityLoveWallModel, index:Int) {
        self.model = model
        avatarImageView.loadAvatar(model.image)
        if model.name == "" {
            self.nickNameLabel.text = "匿名"
        } else {
            self.nickNameLabel.text = model.name
        }
        infoLabel.text      = model.content
        
        self.timeLabel.text = Utilities.getTimeStringForLoveWall(model.date_int)
    }
    
    class func getHeight(model:EECommunityLoveWallModel) -> CGFloat{
        let Height = Utilities.getLabelHeightWithFontSize(model.content, font: UIFont.systemFontOfSize(14), width: ScreenWidth-111)
        return 90 - 17 + Height
    }
    
}
