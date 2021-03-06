//
//  DataEnvironment.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYWebImage

private let _SingletonASharedInstance = DataEnvironment()

class DataEnvironment {
	
	var eduUser:EduUser
	var comUser:ComUser
	var currentWeek = 1 {
		didSet{
			if currentWeek <= 1 {
				currentWeek = 1
			}
		}
	}
	
	var dayCount = 5
	
	//控制推送的变量，外层界面只需要修改其值
	var isPushNotificationEnabled = true {
		didSet {
			if DataEnv.eduUser.isLogin && isPushNotificationEnabled {
				APService.setTags(["push"], alias: DataEnv.eduUser.username, callbackSelector: nil, object: nil)
				PlistManager.shared().saveSettingValueForKey(true, key: "isPushNotificationEnabled")
			} else {
				APService.setTags(["未登录","禁止推送"], alias: "", callbackSelector: nil, object: nil)
				PlistManager.shared().saveSettingValueForKey(false, key: "isPushNotificationEnabled")
			}
		}
	}
	
	//单例
	class func sharedManager() -> DataEnvironment {
		return _SingletonASharedInstance
	}
	
	
	init() {
		eduUser = PlistManager.shared().readEduUser()
		comUser = PlistManager.shared().readComUser()
		isPushNotificationEnabled = (PlistManager.shared().readSettingValueForKey("isPushNotificationEnabled") as? Bool) ?? true
		dayCount = (PlistManager.shared().readSettingValueForKey("dayCount") as? Int) ?? 5
		self.calculateCurrentWeek()
	}
	
	func saveEduUser(user:EduUser) {
		self.eduUser = user
		self.eduUser.isLogin = true
		self.eduUser.hasGetToken = true
		PlistManager.saveEduUser(self.eduUser)
	}
	
	func getEduUserToken(completion:((sccess:Bool,error:String?)->())) {
		if self.eduUser.hasGetToken {
			completion(sccess: true, error: nil)
		} else {
			BCLoginToEduRequest.login(DataEnv.eduUser,
				onLoginBlock: { () -> Void in
					self.eduUser.hasGetToken = true
					completion(sccess: true, error: nil)
				}, onWrongPassWordBlock: { () -> Void in
					completion(sccess: false, error: "登录过期，请重新登录")
				}) { () -> Void in
					completion(sccess: false, error: "网络异常，请稍后再试")
			}
		}
	}
	
	func saveCookie(cookie:String?) {
		if let cookie = cookie {
			if cookie != "" {
				comUser.cookie = cookie
				comUser.isLogin = true
			}
		} else {
		}
	}
	
	func loginComUser() {
		if comUser.isLogin {
			BCCommunityUserLoginRequest.login(comUser.username, password: comUser.password,
				onSuccessBlock: { (response) -> () in
					self.comUser.isLogin = true
					if let data = response["data"] as? NSDictionary{
						if let link = data["image"] as? String {
							self.comUser.avatar = link
							dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
								if let url = NSURL(string:"http://7xlrpg.com1.z0.glb.clouddn.com/icon/" + self.comUser.avatar),
									let data = NSData(contentsOfURL: url) {
										DataEnv.comUser.avatarImage = UIImage(data: data)
								}
							})
							//              let tempImageView = UIImageView()
							//              if let url = NSURL(string: ) {
							//                tempImageView.yy_setImageWithURL(url, placeholder: nil, options: .IgnoreFailedURL , completion: { (image, url, yyWebImageFromType, yyWebImageStage, error) -> Void in
							//                  self.comUser.avatarImage = image
							//                })
							//              }
						}
					}
					self.saveComUser(self.comUser)
				}, onFailedBlock: { (reason) -> () in
					self.comUser.isLogin = false
				}, onNetErrorBlock: { () -> () in
					self.comUser.isLogin = false
			})
		}
	}
	
	func readComUser() -> ComUser{
		return  PlistManager.shared().readComUser()
	}
	
	func saveComUser(user:ComUser) {
		PlistManager.saveComUser(user)
		self.comUser.username = user.username
		self.comUser.password = user.password
		self.comUser.avatar = user.avatar
		self.comUser.isLogin = true
	}
	
	func handleLogOut() {
		self.eduUser = EduUser()
		self.comUser = ComUser()
		PlistManager.deleleEduUser()
		PlistManager.deleleComUser()
		DBManager.sharedManager().deleteGrades()
		DBManager.sharedManager().deleteSchedules()
	}
	
	func calculateCurrentWeek() {
		var from = NSTimeInterval()
		if self.eduUser.schoolYard == "HF" {
			from = NSTimeInterval(HFSemesterStartTime)
		} else {
			from = NSTimeInterval(XCSemesterStartTime)
		}
		
		let now = (NSDate().timeIntervalSince1970)
		self.currentWeek = Int((now - from)/(7 * 24 * 3600)) + 1
		self.getDaysListForWeek(1)
	}
	
	func getDaysListForWeek(week:Int) -> [String] {
		var startData = 0
		if self.eduUser.schoolYard == "HF" {
			startData = (HFSemesterStartTime)
		} else {
			startData = (XCSemesterStartTime)
		}
		
		startData = startData + ((week - 1) * 7 * 24 * 3600)
		
		let formatter = NSDateFormatter()
		formatter.dateFormat = "M-d"
		
		var weekString:[String] = [""]
		
		for i in 0..<7 {
			let day = startData + (i * 24 * 3600)
			let timeInterval = NSTimeInterval(day)
			let date = NSDate(timeIntervalSince1970: timeInterval)
			let string = formatter.stringFromDate(date)
			weekString.append(string)
		}
		return weekString
	}
	
}