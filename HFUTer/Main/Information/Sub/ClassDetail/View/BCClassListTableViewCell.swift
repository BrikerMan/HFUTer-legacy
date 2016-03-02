//
//  BCClassListTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 16/2/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCClassListTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var courseCode: UILabel!
	@IBOutlet weak var courseClassID: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setupWithModel(model:ClassListModel) {
		titleLabel.text		= model.name
		courseCode.text		= "课程代码：" + model.code
		courseClassID.text	= "教学班号：" + model.classNum
	}
    
}
