//
// Created by Eliyar Eziz on 15/11/17.
// Copyright (c) 2015 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit

class EEBaseViewController:UIViewController {

  var navBar = EEBaseNavBar()

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
    }
  }
}

extension EEBaseViewController:EEBaseNavBarDelegate {
  func baseNavBarDidPressOnLeftButton(navBar: EEBaseNavBar) {
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
}
