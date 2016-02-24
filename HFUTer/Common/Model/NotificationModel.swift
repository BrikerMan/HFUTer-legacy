//
//  notificationModel.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 16/2/24.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

/**
警告种类，如果增加只能在其后面增加

- Update:       升级提示
- Notif:        通知
- LoginWarning: 登陆警告
- Other:        其他
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
