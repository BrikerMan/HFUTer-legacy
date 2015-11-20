//
//  ViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {

  private var homeVC = HomeViewController()
  private var communityVC = CommunityViewController()
  private var infoVC = InformationViewController()
  private var personVC = PersonViewController()

  override func viewDidLoad() {
    super.viewDidLoad()
    initUI()
  }

  private func initUI() {
    let homeNav = UINavigationController(rootViewController: homeVC)
    let comNav  = UINavigationController(rootViewController: communityVC)
    let infoNav = UINavigationController(rootViewController: infoVC)
    let personNav = UINavigationController(rootViewController: personVC)

    homeNav.tabBarItem = UITabBarItem(title: "学习", image: nil, tag: 0)
    comNav.tabBarItem = UITabBarItem(title: "社区", image: nil, tag: 0)
    infoNav.tabBarItem = UITabBarItem(title: "查询", image: nil, tag: 0)
    personNav.tabBarItem = UITabBarItem(title: "关于", image: nil, tag: 0)


    homeVC.hideNavBar = true


    viewControllers = [homeNav, comNav, infoNav, personNav]

    for nav in [homeNav, comNav, infoNav, personNav] {
      nav.navigationBarHidden = true
    }
  }

}

