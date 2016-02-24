//
//  File.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Crashlytics

enum EELogEventCategory:String {
	case Community	= "社区"
	case Tool		= "工具类"
	case Info       = "查看信息"
	case TintColor	= "主体颜色"
}

class EELog {
	
	class func log(info:String, file:String = __FILE__, method:String = __FUNCTION__, line: Int = __LINE__) {
		let str = "\(file)[\(line)]-\(method):\(info)"
		print(str)
	}
	
	class func info(info:String) {
		let date = NSDate(timeIntervalSinceNow: 0)
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
		let dataString = formatter.stringFromDate(date)
		let str = "[\(dataString)] " + "INFO:" + info
		print(str)
		
	}
	
	class func error(info:String,param:[String:AnyObject]?) {
		let date = NSDate(timeIntervalSinceNow: 0)
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
		let dataString = formatter.stringFromDate(date)
		let str = "[\(dataString)] " + "ERROR:" + info + "\nParam:\(param)"
		#if DEBUG
			print(str)
		#endif
	}
	
	class func request(url:String,param:NSDictionary?,header:NSDictionary?) {
		let date = NSDate(timeIntervalSinceNow: 0)
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
		let dataString = formatter.stringFromDate(date)
		let str = "=====================\(dataString)=====================\n" + "REQUEST:" + url + "\nHeader:\(header)" + "\nParam:\(param)"
		#if DEBUG
			print(str)
		#endif
	}
	
	class func event(eventName name:String) {
		self.event(eventName: name, attribute: nil)
	}
	
	class func event(eventName name:String,attribute:[String:AnyObject]?) {
		if let att = attribute {
			Answers.logCustomEventWithName(name,customAttributes: att)
		} else {
			Answers.logCustomEventWithName(name,customAttributes: [:])
		}
		
	}
	
	class func eventForCategoty(eventName name:String, category:EELogEventCategory) {
		let action = ["action":name]
		Answers.logCustomEventWithName(category.rawValue,customAttributes: action)
	}
	
}