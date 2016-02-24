//
//  PersonViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class PersonViewController: EEBaseFormViewController {
	
	private var colorChooseView:BCColorChooseView!
	private var colorChooseViewBack:UIView!
	private var isColorChooseViewShowing = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initFormViews()
		navTitle = "我的"
		NotifCenter.addObserver(self, selector: "afterLogin", name: BCUserLoginNotification, object: nil)
		if DataEnv.eduUser.isLogin {
			form.setValues(["isLogin":"edu"])
		}
		self.tableView?.sectionFooterHeight = 0.1
		NotifCenter.addObserver(self, selector: "updatedAvatar", name: EEUserChangedAvatarNotification, object: nil)
	}
	
	
	@objc private func afterLogin() {
		form.setValues(["isLogin":"edu"])
		self.tableView?.reloadData()
	}
	
	override func onTintColorChanged() {
		super.onTintColorChanged()
		self.tableView?.reloadData()
	}
	
	@objc private func updatedAvatar() {
		self.tableView?.reloadData()
	}
	
	private func showColorChooseView() {
		let vc = PersonChooseThemeColorViewController(nib: "PersonChooseThemeColorViewController")
		self.pushToViewController(vc)
	}
	
	private func handeLogOut() {
		NotifCenter.postNotificationName(BCUserLogOutNotification, object: nil)
		DataEnv.handleLogOut()
		form.setValues(["isLogin":"notLogin"])
		self.tableView?.reloadData()
	}
	
	private func initFormViews() {
		
		ButtonRow.defaultCellSetup = { cell, row in
			cell.textLabel?.font = UIFont.systemFontOfSize(16)
			cell.textLabel?.textColor = UIColor(hexString: "333333")
		}
		
		ButtonRow.defaultCellUpdate = { cell, row in
			cell.textLabel?.font = UIFont.systemFontOfSize(16)
			cell.textLabel?.textColor = UIColor(hexString: "333333")
		}
		
		SwitchRow.defaultCellUpdate = { cell, row in
			cell.textLabel?.font = UIFont.systemFontOfSize(16)
			cell.textLabel?.textColor = UIColor(hexString: "333333")
		}
		
		form +++
			Section()
			//用于刷新列表 - 显示隐藏部分cell
			<<< SegmentedRow<String>("isLogin"){
				$0.options = ["notLogin", "edu", "com"]
				$0.value = "notLogin"
				$0.hidden = true
			}
			
			//登录Cell
			<<< ButtonRow("loginButton") {
				$0.title = "登录"
				$0.hidden = "$isLogin != 'notLogin'"
				
				$0.presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback {
					return BCLoginToEduViewController(nib: "BCLoginToEduViewController")
					}, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
				}.cellSetup { cell, row in
					cell.imageView?.image = UIImage(named: "person_login")
			}
			
			//用户详情Cell
			<<< PesonPersonalDetailCellTableViewRow("userDetail") {
				$0.hidden = "$isLogin == 'notLogin'"
				} .onCellSelection({ (cell, row) -> () in
					let vc = PersonDetailViewController()
					self.pushToViewController(vc)
					row.updateCell()
				})
			
			<<< ButtonRow(){
				$0.title = "我的消息"
				}.cellUpdate { cell, row in
					cell.imageView?.image = UIImage(named: "person_massage")
					cell.accessoryType = .DisclosureIndicator
					cell.textLabel?.textAlignment = .Left
				} .onCellSelection({ (cell, row) -> () in
					runAfterLoginToCommunity({ () -> () in
						let vc = PersonMassageListViewController(nib: "PersonMassageListViewController")
						vc.navBar.navLeftButtonStyle = .Back
						vc.hidesBottomBarWhenPushed = true
						self.pushToViewController(vc)
					})
				})
			
			
			+++ Section("设置")
			<<< SwitchRow() {
				$0.title = "接受推送"
				$0.value = DataEnv.isPushNotificationEnabled
				
				$0.onChange({ (row) -> () in
					DataEnv.isPushNotificationEnabled = row.cell.switchControl?.on ?? true
				})
				}.cellSetup { cell, row in
					cell.imageView?.image = UIImage(named: "person_push")
			}
			
			<<< SwitchRow() {
				$0.title = "周末课程显示"
				$0.value = (DataEnv.dayCount == 7)
				
				$0.onChange({ (row) -> () in
					if let showWeekEnd = row.cell.switchControl?.on {
						if showWeekEnd {
							DataEnv.dayCount = 7
							log.eventForCategoty(eventName: "显示周末课程", category: .Tool)
						}
						else { DataEnv.dayCount = 5 }
						PlistManager.shared().saveSettingValueForKey(DataEnv.dayCount, key: "dayCount")
					}
					
					NotifCenter.postNotificationName(EEUserChangedWeekEndSchdeuleSettingNotification, object: nil)
				})
				}.cellSetup { cell, row in
					cell.imageView?.image = UIImage(named: "person_weekEnd")
			}
			
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "主题颜色"
				row.presentationMode = .Show(controllerProvider: ControllerProvider.Callback {
					let vc = PersonChooseThemeColorViewController(nib: "PersonChooseThemeColorViewController")
					vc.navBar.navLeftButtonStyle = .Back
					vc.navTitle = "主题色选择"
					vc.hidesBottomBarWhenPushed = true
					vc.colorChoosedBlock = {(colorDic) in
						Color.primaryTintColor = colorDic.color
						log.eventForCategoty(eventName: colorDic.name, category: .TintColor)
					}
					
					return vc
					}, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
				}.cellSetup { cell, row in
					cell.imageView?.image = UIImage(named: "person_theme")
			}
			
			/*
			+++ Section("研究生专用，禁止自动加载课表和成绩")
			<<< SwitchRow() {
			$0.title = "禁止自动加载 - 暂不可用"
			$0.value = true
			}.cellSetup { cell, row in
			cell.imageView?.image = UIImage(named: "person_autoload")
			}
			*/
			
			+++ Section() {
				$0.footer = HeaderFooterView<PersonViewFooterView>(HeaderFooterProvider.Class)
				$0.footer?.height = { 30 }
			}
			
			
			<<< ButtonRow() {
				$0.title = "帮助 "
				$0.presentationMode = .Show(controllerProvider: ControllerProvider.Callback {
					let vc = PersonHelpViewController(nib: "PersonHelpViewController")
					vc.style = .Help
					vc.hidesBottomBarWhenPushed = true
					return vc
					}, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
				}.cellSetup { cell, row in
					cell.imageView?.image = UIImage(named: "person_help")
			}
			
			<<< ButtonRow() {
				$0.title = "关于我们"
				$0.presentationMode = .Show(controllerProvider: ControllerProvider.Callback {
					let vc = PersonHelpViewController(nib: "PersonHelpViewController")
					vc.style = .AboutUs
					vc.hidesBottomBarWhenPushed = true
					return vc
					}, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
				}.cellSetup { cell, row in
					cell.imageView?.image = UIImage(named: "person_about")
			}
			
			<<< ButtonRow() {
				$0.title = "隐私条款"
				$0.presentationMode = .Show(controllerProvider: ControllerProvider.Callback {
					let vc = PersonHelpViewController(nib: "PersonHelpViewController")
					vc.style = .PrivacyPoicy
					vc.hidesBottomBarWhenPushed = true
					return vc
					}, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
				}.cellSetup { cell, row in
					cell.imageView?.image = UIImage(named: "person_legal")
			}
			
			+++ Section() {
				if !DataEnv.eduUser.isLogin { $0.hidden = true }
			}
			
			<<< ButtonRow() {
				$0.title = "退出"
				$0.hidden = "$isLogin == 'notLogin'"
				} .onCellSelection({ (cell, row) -> () in
					let alertView = UIAlertView()
					alertView.title = "是否确认退出"
					alertView.message = "同时推出教务系统和社区，退出后缓存的课表等数据将情况，自定义备注被删除。请确认是否退出。"
					alertView.addButtonWithTitle("确认退出")
					alertView.addButtonWithTitle("取消")
					alertView.cancelButtonIndex = 1
					alertView.tag = 1
					alertView.delegate = self
					alertView.show()
				})
		
	}
}


extension PersonViewController:UIAlertViewDelegate {
	func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		if buttonIndex == 0 {
			self.handeLogOut()
		}
	}
}