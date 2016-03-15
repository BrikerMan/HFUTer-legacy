//
//  HFLoveWallCommentCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 16/3/13.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFLoveWallCommentCell: UITableViewCell {

    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var avatrImageView: EEImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatrImageView.layer.cornerRadius = 25/2
        avatrImageView.layer.borderWidth  = 1
        avatrImageView.layer.borderColor = Color.primaryTintColor.CGColor
        lineView1.backgroundColor = Color.primaryTintColor
        lineView2.backgroundColor = Color.primaryTintColor
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupWithModel(model: EECommunityLoveCommentModel) {
        avatrImageView.loadAvatar(model.image)
        if model.name == "" {
            self.nickNameLabel.text = "匿名"
        } else {
            self.nickNameLabel.text = model.name
        }
        
        timeLabel.text = Utilities.getTimeStringForLoveWall(model.date_int)
        if model.at.count != 0 {
            self.infoLabel.text = "@" + model.at[0].name + " " + model.content
        } else {
            self.infoLabel.text = model.content
        }

    }
    
    static func getHightForModel(model:EECommunityLoveCommentModel) -> CGFloat{
        let height = Utilities.getLabelHeightWithFontSize(model.content, font: UIFont.systemFontOfSize(14), width: ScreenWidth-111)
        return 52 + height
    }
    
}
