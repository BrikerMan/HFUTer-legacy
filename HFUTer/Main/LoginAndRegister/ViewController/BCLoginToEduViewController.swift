//
//  BCLoginViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/9/9.
//  Copyright (c) 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCLoginToEduViewController: EEBaseViewController {
	
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var schoolYardChoose: UISegmentedControl!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var loginView: UIView!
	
	@IBOutlet weak var loginWarningView: UIView!
	@IBOutlet weak var loginWarningInfo: UILabel!
	
	private var isLoginRequestGoing = false
	private var isViewSlided = false
	
	private var wrongPassTime = 0 {
		didSet {
			if wrongPassTime >= 2 {
				var mass = ""
				if  schoolYardChoose.selectedSegmentIndex == 0 {
					mass = "请使用信息门户(my.hfut.edu.cn)密码\n若多次登录失败，请尝试用电脑端登录验证密码\n其他问题请加测试QQ群(117196247)反馈"
				} else {
					mass = "请使用教务系统(222.195.8.201)密码\n若多次登录失败，请尝试用电脑端登录验证密码\n其他问题请加测试QQ群(117196247)反馈"
				}
				self.showWarningViewWithInfo(mass)
			}
		}
	}
	
	//  private var hud:WSProgressHUD!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navBar.hidden = true
		loginButton.layer.cornerRadius = 5
		cancelButton.layer.cornerRadius = 5
		loginWarningView.layer.cornerRadius = 3
		loginWarningView.hidden = true
		self.loginView.backgroundColor = Color.primaryTintColor
		
		let tapGasture = UITapGestureRecognizer(target: self, action: "onTapGasturePressed")
		self.view.addGestureRecognizer(tapGasture)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector:"hasReceivedLoginWarningNotif", name: EEHasReceiveLoginWarningNotification, object: nil)
		
		if EENotificationManager.shared.hasLoginWarningNotification {
			if let notif = EENotificationManager.shared.loginWarningNotification {
				self.showWarningViewWithInfo(notif.message)
			}
		}
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: EEHasReceiveLoginWarningNotification, object: nil)
	}
	
	
	@objc private func onTapGasturePressed() {
		self.view.endEditing(true)
	}
	
	
	
	@IBAction func onLoginButtonPress(sender: AnyObject) {
		if usernameField.text != "" && passwordField.text != "" {
			startLoginRequest()
		} else {
			Hud.showError("请填写信息")
		}
		self.view.endEditing(true)
	}
	
	@IBAction func onCancelButtonPress(sender: AnyObject) {
		super.pop()
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func onHelpButtonPressed(sender: AnyObject) {
		//    let vc = BCHelpViewController(nibName:"BCHelpViewController",bundle:nil)
		//    self.pushToViewController(vc)
	}
	
	func startLoginRequest() {
		if !isLoginRequestGoing {
			Hud.showLoadingWithMask("正在登录")
			isLoginRequestGoing = true
			let user = EduUser()
			user.username = usernameField.text!
			user.password = passwordField.text!
			if schoolYardChoose.selectedSegmentIndex == 0 {
				user.schoolYard = "HF"
			} else {
				user.schoolYard = "XC"
			}
			
			BCLoginToEduRequest.login(user,
				onLoginBlock: { () -> Void in
					Hud.dismiss()
					user.isLogin = true
					user.showWeekEnd = false
					DataEnv.saveEduUser(user)
					self.isLoginRequestGoing = false
					self.getUserDetail(user)
				}, onWrongPassWordBlock: { () -> Void in
					Hud.showError("帐号或密码错误")
					self.wrongPassTime += 1
					self.isLoginRequestGoing = false
				}) { () -> Void in
					Hud.showError("网络错误")
					self.isLoginRequestGoing = false
			}
		}
	}
	
	
	//TODO: 处理登录后的
	func getUserDetail(user: EduUser) {
		Hud.showLoadingWithMask("正在获取用户信息")
		BCGetUserDetailFromEduRequest.get(user, onSuccessGetBlock: { () -> Void in
			Hud.dismiss()
			DataEnv.saveEduUser(user)
			self.dismissViewControllerAnimated(true, completion: nil)
			self.pop()
			NotifCenter.postNotificationName(BCUserLoginNotification, object: nil)
			
			}, onParseFailBlock: { () -> Void in
				Hud.dismiss()
				self.dismissViewControllerAnimated(true, completion: nil)
				self.pop()
				NotifCenter.postNotificationName(BCUserLoginNotification, object: nil)
				
			}) { () -> Void in
				Hud.dismiss()
				self.dismissViewControllerAnimated(true, completion: nil)
				self.pop()
				NotifCenter.postNotificationName(BCUserLoginNotification, object: nil)
				
		}
	}
	
	func showWarningViewWithInfo(info:String) {
		loginWarningView.hidden = false
		loginWarningInfo.text = info
	}
	
	@objc func hasReceivedLoginWarningNotif() {
		if EENotificationManager.shared.hasLoginWarningNotification {
			if let notif = EENotificationManager.shared.loginWarningNotification {
				self.showWarningViewWithInfo(notif.message)
			}
		}
	}
	
}
