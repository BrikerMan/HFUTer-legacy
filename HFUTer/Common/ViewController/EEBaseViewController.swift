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
  
  //MARK:- 初始化
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  convenience init(nib:String) {
    self.init(nibName: nib, bundle: nil)
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
  
  //MARK:- 生命周期
  override func viewDidLoad() {
    super.viewDidLoad()
    initUI()
    view.backgroundColor = UIColor.whiteColor()
    NotifCenter.addObserver(self, selector: "onTintColorChanged", name: BCChangeTintColorNotification, object: nil)
  }
  
  //MARK:- 状态改变
  func afterUserLogin(notificaiton:NSNotification) {
    
  }
  
  func onTintColorChanged() {
    self.navBar.view?.backgroundColor = Color.primaryTintColor
  }
  
  //MARK:- 点击动作
  func showNavRightButtonWithIcon(iconName:String) {
    navBar.showNavRightButtonWithIcon(iconName)
  }
  
  func onRightNavButtonPress() {
    
  }
  

  //MARK:- 快捷入口
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
    Hud.dismiss()
    self.navigationController?.popViewControllerAnimated(true)
  }
  
}

extension EEBaseViewController:EEBaseNavBarDelegate {
  func baseNavBarDidPressOnLeftButton(navBar: EEBaseNavBar) {
    self.pop()
  }
  
  func baseNavBarDidPressOnRightButton(navBar: EEBaseNavBar) {
    self.onRightNavButtonPress()
  }
}
