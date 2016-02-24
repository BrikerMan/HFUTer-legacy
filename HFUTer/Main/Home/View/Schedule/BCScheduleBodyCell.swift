//
//  BCScheduleBodyCell.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCScheduleBodyCell: UICollectionViewCell {
	
	@IBOutlet weak var classNameLabel: UILabel!
	@IBOutlet weak var classLocateLabel: UILabel!
	
	var models:[ScheduleModel]?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	
	func setupCellModels(models:[ScheduleModel]?) {
		if let models = models {
			self.models = models
			var className = ""
			var Place = ""
			if models.count == 1 {
				className = models[0].name
				Place     = models[0].place
			} else {
				for model in models {
					if model.name != models.last!.name {
						className += getShortStringOf(model.name) + " / "
						Place     += model.place + " / "
					} else {
						className += getShortStringOf(model.name)
						Place     += model.place
					}
				}
			}
			self.classNameLabel.text = className
			self.classLocateLabel.text = Place
			self.backgroundColor = Color.getRandomFlatColorForCode(models[0].name)
		} else {
			self.models = nil
			classNameLabel.text = ""
			classLocateLabel.text = ""
			self.backgroundColor = UIColor.whiteColor()
		}
	}
	
	private func getShortStringOf(origin:String) -> String {
		if origin.characters.count > 5 {
			return origin[0..<5]
		} else {
			return origin
		}
	}
}
