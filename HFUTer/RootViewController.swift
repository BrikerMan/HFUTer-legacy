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

    homeNav.tabBarItem = UITabBarItem(title: "学习", image: UIImage(named:"tabbar_study"), selectedImage: UIImage(named:"tabbar_study_fill"))
    comNav.tabBarItem = UITabBarItem(title: "查询", image: UIImage(named:"tabbar_community"), selectedImage: UIImage(named:"tabbar_community_fill"))
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
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func showLoginToSchoolVC() {
    let vc = BCLoginToEduViewController(nibName:"BCLoginToEduViewController",bundle:nil)
    self.navigationController?.pushViewController(vc, animated: true)
  }

}

