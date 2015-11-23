//
// Created by Eliyar Eziz on 15/11/17.
// Copyright (c) 2015 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit
import FontAwesome_swift

class EEBaseViewController:UIViewController {
  
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
    NotifCenter.addObserver(self, selector: "onTintColorChanged", name: BCChangeTintColorNotification, object: nil)
  }
  
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
  }
}

extension EEBaseViewController:EEBaseNavBarDelegate {
  func baseNavBarDidPressOnLeftButton(navBar: EEBaseNavBar) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func baseNavBarDidPressOnRightButton(navBar: EEBaseNavBar) {
    self.onRightNavButtonPress()
  }
}
