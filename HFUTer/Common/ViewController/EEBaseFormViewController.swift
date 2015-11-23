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
  
  //生命周期
  deinit {
    NotifCenter.removeObserver(self, name: BCChangeTintColorNotification, object: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initUI()
    view.backgroundColor = UIColor.whiteColor()
    NotifCenter.addObserver(self, selector: "onTintColorChanged", name: BCChangeTintColorNotification, object: nil)
  }
  
  //动作响应
  func afterUserLogin(notificaiton:NSNotification) {
    
  }
  
  func showNavRightButtonWithIcon(iconName:String) {
    navBar.showNavRightButtonWithIcon(iconName)
  }
  
  func onRightNavButtonPress() {
    
  }
  
  func onTintColorChanged() {
    self.navBar.view?.backgroundColor = Color.primaryTintColor
  }
  
  func pushToViewController(vc:UIViewController) {
    vc.hidesBottomBarWhenPushed = true
    if let vc = vc as? EEBaseViewController {
      vc.navBar.navLeftButtonStyle = .Back
    }
    if let vc = vc as? EEBaseFormViewController {
      vc.navBar.navLeftButtonStyle = .Back
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func pop() {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  //初始化UI
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
      
      navBar.view?.backgroundColor = Color.primaryTintColor
      navBar.navRightButton.hidden = true
    }
    self.tableView?.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49)
  }
}

extension EEBaseFormViewController:EEBaseNavBarDelegate {
  func baseNavBarDidPressOnLeftButton(navBar: EEBaseNavBar) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func baseNavBarDidPressOnRightButton(navBar: EEBaseNavBar) {
    self.onRightNavButtonPress()
  }
}
