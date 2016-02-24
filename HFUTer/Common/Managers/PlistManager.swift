//
//  PlistManager.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import UIKit

private let _SingletonASharedInstance = PlistManager()


class PlistManager {
	
	private var filePath:String
	
	private init() {
		let mypaths:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
		filePath = mypaths.objectAtIndex(0) as! String
	}
	
	class func shared() -> PlistManager{
		return _SingletonASharedInstance
	}
	
	func readPlistFile(fileName:String) -> NSDictionary?{
		let filePath = self.filePath + "/" + fileName
		let dataSource = NSDictionary(contentsOfFile: filePath)
		return dataSource
	}
	
	func readEduUser() -> EduUser{
		let dataSource = readPlistFile("user.plist")
		let user = EduUser()
		user.username     = dataSource?.objectForKey("username")    as? String ?? "000"
		user.password     = dataSource?.objectForKey("password")    as? String ?? ""
		user.schoolYard   = dataSource?.objectForKey("schoolYard")  as? String ?? ""
		user.showWeekEnd  = dataSource?.objectForKey("showWeekEnd") as? Bool   ?? false
		user.name         = dataSource?.objectForKey("name")        as? String ?? "请登录"
		user.gender       = dataSource?.objectForKey("gender")      as? String ?? ""
		user.academy      = dataSource?.objectForKey("academy")     as? String ?? ""
		user.major        = dataSource?.objectForKey("major")       as? String ?? ""
		user.className    = dataSource?.objectForKey("className")   as? String ?? ""
		if user.username != "000" {
			user.isLogin = true
		}
		return user
	}
	
	class func getFilePath(filename: String) -> String {
		let mypaths:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
		let mydocpath:String = mypaths.objectAtIndex(0) as! String
		
		let filepath = (mydocpath as NSString).stringByAppendingPathComponent(filename)
		return filepath
	}
	
	class func readEduUser() -> EduUser{
		let filePath = self.getFilePath("user.plist")
		let dataSource = NSDictionary(contentsOfFile: filePath)
		let user = EduUser()
		
		if let dataSource = dataSource {
			user.username     = dataSource.objectForKey("username")    as? String ?? "000"
			user.password     = dataSource.objectForKey("password")    as? String ?? ""
			user.schoolYard   = dataSource.objectForKey("schoolYard")  as? String ?? ""
			user.showWeekEnd  = dataSource.objectForKey("showWeekEnd") as? Bool   ?? false
			user.name         = dataSource.objectForKey("name")        as? String ?? "请登录"
			user.gender       = dataSource.objectForKey("gender")      as? String ?? ""
			user.academy      = dataSource.objectForKey("academy")     as? String ?? ""
			user.major        = dataSource.objectForKey("major")       as? String ?? ""
			user.className    = dataSource.objectForKey("className")   as? String ?? ""
			if user.username != "000" {
				user.isLogin = true
			}
		}
		
		return user
	}
	
	class func saveEduUser(user:EduUser) {
		let filePath = self.getFilePath("user.plist")
		let dataSource:NSMutableDictionary = ["key":"value"]
		dataSource.setValue(user.username, forKey: "username")
		dataSource.setValue(user.password, forKey: "password")
		dataSource.setValue(user.schoolYard, forKey: "schoolYard")
		dataSource.setValue(user.showWeekEnd, forKey: "showWeekEnd")
		dataSource.setValue(user.name, forKey: "name")
		dataSource.setValue(user.gender, forKey: "gender")
		dataSource.setValue(user.academy, forKey: "academy")
		dataSource.setValue(user.major, forKey: "major")
		dataSource.setValue(user.className, forKey: "className")
		dataSource.writeToFile(filePath, atomically: true)
	}
	
	class func deleleEduUser() {
		let filePath = self.getFilePath("user.plist")
		let dataSource:NSMutableArray = []
		dataSource.writeToFile(filePath, atomically: true)
	}
	
	func readComUser() -> ComUser{
		let filePath = PlistManager.getFilePath("comUser.plist")
		let dataSource = NSDictionary(contentsOfFile: filePath)
		let user = ComUser()
		if let dataSource = dataSource {
			if let username = dataSource.objectForKey("username") as? String,password = dataSource.objectForKey("password") as? String {
				if username != "" && password != "" {
					user.username = username
					user.password = password
					user.isLogin = true
					
				}
				if let avatar = dataSource.objectForKey("avatar") as? String {
					user.avatar = avatar
				}
			}
		}
		return user
	}
	
	func readSettingValueForKey(key:String) -> AnyObject? {
		let filePath = PlistManager.getFilePath("settings.plist")
		if let dataSource = NSDictionary(contentsOfFile: filePath), let value = dataSource[key] {
			return value
		} else {
			return nil
		}
	}
	
	func saveSettingValueForKey(value:AnyObject,key:String) {
		let filePath = PlistManager.getFilePath("settings.plist")
		var data = NSMutableDictionary()
		if let fileContent = NSMutableDictionary(contentsOfFile: filePath) {
			data = fileContent
		}
		data.setValue(value, forKey: key)
		data.writeToFile(filePath, atomically: true)
	}
	
	class func saveComUser(user:ComUser) {
		let filePath = PlistManager.getFilePath("comUser.plist")
		let dataSource:NSMutableDictionary = ["key":"value"]
		dataSource.setValue(user.username, forKey: "username")
		dataSource.setValue(user.password, forKey: "password")
		dataSource.setValue(user.avatar, forKey: "avatar")
		dataSource.writeToFile(filePath, atomically: true)
	}
	
	class func deleleComUser() {
		let filePath = self.getFilePath("comUser.plist")
		let dataSource:NSMutableArray = []
		dataSource.writeToFile(filePath, atomically: true)
	}
	
	
	func saveTintColor(color:UIColor) {
		let colorString = color.hexString ?? "#F86366"
		self.saveSettingValueForKey(colorString, key: "tintColor")
	}
	
	
	func readTintColor() {
		let hex = readSettingValueForKey("tintColor") as? String ?? "#F86366"
		let tintColor = UIColor(hexString: hex, alpha: 1.0)
		Color.primaryTintColor = tintColor
	}
	
	func readColorDic() -> [String:String] {
		let filePath = PlistManager.getFilePath("courseColors.plist")
		if let dic = NSDictionary(contentsOfFile: filePath), colorDic = dic as? [String:String] {
			return colorDic
		}
		return [String:String]()
	}
	
	func saveColorDic(colorDic:[String:String]) {
		let filePath = PlistManager.getFilePath("courseColors.plist")
		(colorDic as NSDictionary).writeToFile(filePath, atomically: true)
	}
}