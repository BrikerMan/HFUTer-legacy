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
  
  //Hud 管理页面
  private var hudView = UIView()
  private var badge:RKNotificationHub!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initUI()
    NotifCenter.addObserver(self, selector: "onTintColorChanged", name: BCChangeTintColorNotification, object: nil)
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
    
    self.view.addSubview(hudView)
    hudView.userInteractionEnabled = false
    hudView.snp_makeConstraints { (make) -> Void in
      make.bottom.equalTo(self.view.snp_bottom)
      make.height.equalTo(49)
      make.width.equalTo(ScreenWidth/4)
      make.right.equalTo(self.view.snp_right).offset(-ScreenWidth/4)
    }
    
    let width = ScreenWidth/4
    
    badge = RKNotificationHub(view: hudView)
    badge.setCircleColor(UIColor.flatRedColor(), labelColor: UIColor.whiteColor())
    badge.setCircleAtFrame(CGRectMake(width/2+5,0, 20, 20))
  }

  func showLoginToCommunityVC() {
    let vc = BCCommunitLoginViewController(nibName:"BCCommunitLoginViewController",bundle:nil)
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func showLoginToSchoolVC() {
    let vc = BCLoginToEduViewController(nibName:"BCLoginToEduViewController",bundle:nil)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func onTintColorChanged() {
    appDelegate.window?.tintColor = Color.primaryTintColor
  }
  
  func addRedBundle() {
    badge.increment()
    badge.pop()
  }

}

