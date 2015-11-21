//
//  EEBaseFormViewController.swift
//  Hande
//
//  Created by Eliyar Eziz on 15/11/17.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class EEBaseFormViewController:FormViewController {

  var navBar = EEBaseNavBar()
  var navTitle = "" {
    didSet {
      navBar.titleLabel.text = navTitle
    }
  }

  var hideNavBar = false {
    didSet {
      if hideNavBar {
        navBar.hidden = true
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    initUI()
    view.backgroundColor = UIColor.whiteColor()
  }

  func afterUserLogin(notificaiton:NSNotification) {

  }


  func pushToViewController(vc:UIViewController) {
    vc.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func pop() {
    self.navigationController?.popViewControllerAnimated(true)
  }


  private func initUI() {
    self.automaticallyAdjustsScrollViewInsets = false
    if !hideNavBar {
      navBar.delegate = self
      self.view.addSubview(navBar)

      navBar.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(self.view.snp_left)
        make.right.equalTo(self.view.snp_right)
        make.top.equalTo(self.view.snp_top)
        make.height.equalTo(64)
      }
    }
    self.tableView?.frame = CGRectMake(0, 64, self.view.frame.width, self.view.frame.height-64-49)
  }

}

extension EEBaseFormViewController:EEBaseNavBarDelegate {
  func baseNavBarDidPressOnLeftButton(navBar: EEBaseNavBar) {
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
}