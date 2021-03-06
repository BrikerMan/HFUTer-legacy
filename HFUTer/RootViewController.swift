//
//  ViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit
import RKNotificationHub

class RootViewController: UITabBarController {
	
	private var homeVC = HomeViewController()
	private var communityVC = CommunityViewController(nib: "CommunityViewController")
	private var infoVC = InformationViewController(nib: "InformationViewController")
	private var personVC = PersonViewController()
	
	private var homeNav:UINavigationController!
	private var comNav:UINavigationController!
	private var infoNav:UINavigationController!
	private var personNav:UINavigationController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initUI()
		EENotificationManager.shared.checkForNotification()
		NotifCenter.addObserver(self, selector: "onTintColorChanged", name: BCChangeTintColorNotification, object: nil)
		NotifCenter.addObserver(self, selector: "receivedNotifNotification", name: EEHasReceiveNotifNotification, object: nil)
		NotifCenter.addObserver(self, selector: "receivedNotifNotification", name: EEHasReceiveUpdateNotification, object: nil)
		if EENotificationManager.shared.hasNotifNotification {
			receivedNotifNotification()
		}
	}
	
	private func initUI() {
		homeNav = UINavigationController(rootViewController: homeVC)
		comNav  = UINavigationController(rootViewController: communityVC)
		infoNav = UINavigationController(rootViewController: infoVC)
		personNav = UINavigationController(rootViewController: personVC)
		
		homeNav.tabBarItem = UITabBarItem(title: "学习", image: UIImage(named:"tabbar_study"), selectedImage: UIImage(named:"tabbar_study_fill"))
		comNav.tabBarItem = UITabBarItem(title: "社区", image: UIImage(named:"tabbar_community"), selectedImage: UIImage(named:"tabbar_community_fill"))
		infoNav.tabBarItem = UITabBarItem(title: "查询", image: UIImage(named:"tabbar_search"), selectedImage: UIImage(named:"tabbar_search_fill"))
		personNav.tabBarItem = UITabBarItem(title: "我的", image: UIImage(named:"tabbar_user"), selectedImage: UIImage(named:"tabbar_user_fill"))
		
		homeVC.hideNavBar = true
		
		viewControllers = [homeNav, comNav, infoNav, personNav]
		
		for nav in [homeNav, comNav, infoNav, personNav] {
			nav.navigationBarHidden = true
		}
	}
	
	func showLoginToCommunityVC() {
		let vc = BCCommunitLoginViewController(nibName:"BCCommunitLoginViewController",bundle:nil)
		vc.navBar.navLeftButtonStyle = .Back
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	func showLoginToSchoolVC() {
		let vc = BCLoginToEduViewController(nibName:"BCLoginToEduViewController",bundle:nil)
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	func onTintColorChanged() {
		appDelegate.window?.tintColor = Color.primaryTintColor
	}
	
	func receivedNotifNotification() {
		delay(seconds: 5, completion: { () -> () in
			dispatch_async(dispatch_get_main_queue()) { () -> Void in
				if let notif = EENotificationManager.shared.updateOrNotifNotification {
					let alert = EENotifView()
					alert.setupWithModel(notif)
					self.view.addSubview(alert)
					
					alert.snp_makeConstraints(closure: { (make) -> Void in
						make.edges.equalTo(self.view)
					})
				}
				
			}
		})
	}
}

