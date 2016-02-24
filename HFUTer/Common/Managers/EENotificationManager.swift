//
//  EENotificationManager.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 16/2/24.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

/**
警告种类，如果增加只能在其后面增加

- Update:       升级提示		0
- Notif:        通知			1
- LoginWarning: 登陆警告		2
- Other:        其他			3
*/
enum NotificationType: Int {
	case Update = 0
	case Notif  = 1
	case LoginWarning = 2
	case Other  = 3
}


class NotificationModel: NSObject {
	var id:Int = 0
	var date:Int = 0
	var lastVersion = ""
	var forVersion  = ""
	var title = ""
	var message  = ""
	var updateLink = ""
	var type:NotificationType  = NotificationType(rawValue: 0)!
	var hasIgnored = false
}



class EENotificationManager {
	static let shared = EENotificationManager()
	
	var notifications:[NotificationModel] = []
	
	var updateOrNotifNotification:NotificationModel?
	var loginWarningNotification:NotificationModel?
	var otherNotification:NotificationModel?
	
	var hasUpdateNotification		= false
	var hasNotifNotification			= false
	var hasLoginWarningNotification = false
	var hasOtherNotification			= false
	
	
	func checkForNotification() {
		BCBaseRequest.getJsonRequest(notificationJsonFileURL, params: [String:AnyObject](), onFinishedBlock: { (response) -> Void in
			
			PlistManager.shared().saveSettingValueForKey(response, key: "notifications")
			if let items = response.valueForKey("list") as? NSArray {
				for item in items {
					let model = NotificationModel.yy_modelWithJSON(item)
					if let type = item.valueForKey("type") as? Int, modelType = NotificationType(rawValue: type) {
						model.type = modelType
					}
					self.notifications.append(model)
				}
			}
			
			
			if let ignoreList = PlistManager.shared().readSettingValueForKey("ignoredNotification") as? [Int] {
				for notif in self.notifications where ignoreList.contains(notif.id) {
					notif.hasIgnored = true
				}
			}
			
			self.postNotifications()
			
			}) { (error) -> Void in
				
		}
	}
	
	func checkIsSuitForThisVersion(notif:NotificationModel) -> Bool {
		if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
		{
			let cuurentVersion = (version as NSString).doubleValue
			if (notif.forVersion as NSString).doubleValue == cuurentVersion {
				return true
			}
			if (notif.lastVersion as NSString).doubleValue >= cuurentVersion {
				return true
			}
		}
		
		return false
	}
	
	func addToNotificationList(notif:NotificationModel) {
		var ignoreListData = NSMutableArray()
		if let ignoreList = PlistManager.shared().readSettingValueForKey("ignoredNotification") as? NSMutableArray {
			ignoreListData = ignoreList
		}
		ignoreListData.addObject(notif.id)
		PlistManager.shared().saveSettingValueForKey(ignoreListData, key: "ignoredNotification")
	}
	
	func postNotifications() {
		for notif in notifications {
			switch notif.type {
			case .Update:
				if !notif.hasIgnored && checkIsSuitForThisVersion(notif) {
					NSNotificationCenter.defaultCenter().postNotificationName(EEHasReceiveUpdateNotification, object: nil)
					self.hasUpdateNotification = true
					self.updateOrNotifNotification = notif
				}
			case .Notif:
				if !notif.hasIgnored && checkIsSuitForThisVersion(notif) {
					NSNotificationCenter.defaultCenter().postNotificationName(EEHasReceiveNotifNotification, object: nil)
					self.hasNotifNotification = true
					self.updateOrNotifNotification = notif
				}
			case .LoginWarning:
				if !notif.hasIgnored && checkIsSuitForThisVersion(notif) {
					NSNotificationCenter.defaultCenter().postNotificationName(EEHasReceiveLoginWarningNotification, object: nil)
					self.hasLoginWarningNotification = true
					self.loginWarningNotification = notif
				}
			case .Other:
				if !notif.hasIgnored && checkIsSuitForThisVersion(notif) {
					NSNotificationCenter.defaultCenter().postNotificationName(EEHasReceiveOtherNotification, object: nil)
					self.hasOtherNotification = true
					self.otherNotification = notif
				}
			}
		}
	}
}