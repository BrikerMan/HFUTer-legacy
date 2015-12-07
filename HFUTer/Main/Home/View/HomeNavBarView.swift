//
//  HomeNavBarView.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import DGRunkeeperSwitch

protocol HomeNavBarViewDelegate {
  func homeNavBar(NavBar homeNavBar:HomeNavBarView,didSelecectedAtIndex index:Int)
  func homeNavBarDidPressObSelcetWeekView(NavBar: HomeNavBarView)
}

class HomeNavBarView:EEXibView {
  
  var delegate:HomeNavBarViewDelegate?
  
  var runkeeperSwitch:DGRunkeeperSwitch!
  private var isTriggerByScrollView = false
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var slideDownImage: UIImageView!
  @IBOutlet weak var notLoginLabel: UILabel!
  
  override func initFromXib() {
    super.initFromXib()
    self.view?.backgroundColor = Color.primaryTintColor
    
    runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "课程表", rightTitle: "成绩")
    runkeeperSwitch.layer.cornerRadius = 26/2
    runkeeperSwitch.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.298731161347518)
    runkeeperSwitch.selectedBackgroundColor = .whiteColor()
    runkeeperSwitch.titleColor = .whiteColor()
    runkeeperSwitch.selectedTitleColor = Color.primaryTintColor
    runkeeperSwitch.titleFont = UIFont.systemFontOfSize(13)
    runkeeperSwitch.addTarget(self, action: "runkeeperSwitchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    view!.addSubview(runkeeperSwitch)
    
    runkeeperSwitch.snp_makeConstraints { (make) -> Void in
      make.width.equalTo(160)
      make.height.equalTo(26)
      make.centerY.equalTo(self.titleLabel.snp_centerY)
      make.centerX.equalTo(self.snp_centerX)
    }
  }
  
  func setSwitchToIndex(index:Int) {
    isTriggerByScrollView = true
    runkeeperSwitch.setSelectedIndex(index, animated: true)
  }
  
  func initUserLogin(isLogin:Bool) {
    if isLogin {
      notLoginLabel.hidden = true
      slideDownImage.hidden = false
      titleLabel.hidden = false
      runkeeperSwitch.hidden = false
    } else {
      notLoginLabel.hidden = false
      slideDownImage.hidden = true
      titleLabel.hidden = true
      runkeeperSwitch.hidden = true
    }

  }
  
  @objc private func runkeeperSwitchValueChanged() {
    if !isTriggerByScrollView {
      delegate?.homeNavBar(NavBar: self, didSelecectedAtIndex: runkeeperSwitch.selectedIndex)
    } else {
      isTriggerByScrollView = false
    }
  }
  
  @IBAction func onShowSelectWeekViewButtonPress(sender: AnyObject) {
    delegate?.homeNavBarDidPressObSelcetWeekView(self)
  }
  
}