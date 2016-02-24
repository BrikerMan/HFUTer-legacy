//
//  EENotifView.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 16/2/24.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class EENotifView: EEXibView {
	
	var model:NotificationModel!
	
	@IBOutlet weak var containView: UIView!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var messageLabel: UILabel!
	
	@IBOutlet weak var okActionButton: UIButton!
	@IBOutlet weak var cancelActionButton: UIButton!
	
	@IBOutlet weak var containViewHeight: NSLayoutConstraint!
	
	/*
	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
	// Drawing code
	}
	*/
	
	override func initFromXib() {
		super.initFromXib()
		okActionButton.backgroundColor = Color.primaryTintColor
		containView.clipsToBounds = true
		containView.layer.cornerRadius = 1
	}
	
	
	func setupWithModel(model:NotificationModel) {
		self.model = model
		titleLabel.text = model.title
		dateLabel.text  = Utilities.getTimeStringFromTimeStamp(model.date)
		messageLabel.text = model.message
		
		let height = Utilities.getLabelHeightWithFontSize(model.message, font: UIFont.systemFontOfSize(10), width: 280)
		containViewHeight.constant = height + 105
		self.view?.layoutIfNeeded()
		
		if model.type == .Update {
			okActionButton.setTitle("更新", forState: UIControlState.Normal)
			cancelActionButton.setTitle("取消", forState: UIControlState.Normal)
		}
		
	}
	
	@IBAction func okButtonAction(sender: AnyObject) {
		if model.type == .Update {
			if let url = NSURL(string: model.updateLink) {
				UIApplication.sharedApplication().openURL(url)
			}
		}
		self.removeFromSuperview()
	}
	
	@IBAction func ignoreButtonAction(sender: AnyObject) {
		if model.type != .Update {
			EENotificationManager.shared.addToNotificationList(model)
		}
		self.removeFromSuperview()
	}
}
