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
  func homeNavBar(NavBar homeNavBar:HomeNavBarView,didPressObSelcetWeekView isOpen:Bool)
}

class HomeNavBarView:EEXibView {

  var delegate:HomeNavBarViewDelegate?

  private var runkeeperSwitch:DGRunkeeperSwitch!

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var slideDownImage: UIImageView!

  override func initFromXib() {
    super.initFromXib()
    self.view?.backgroundColor = Color.primaryTintColor

    runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "课程表", rightTitle: "成绩")
    runkeeperSwitch.layer.cornerRadius = 15
    runkeeperSwitch.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.298731161347518)
    runkeeperSwitch.selectedBackgroundColor = .whiteColor()
    runkeeperSwitch.titleColor = .whiteColor()
    runkeeperSwitch.selectedTitleColor = self.view?.backgroundColor ?? UIColor(red: 239.0/255.0, green: 95.0/255.0, blue: 49.0/255.0, alpha: 1.0)
    runkeeperSwitch.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)
    runkeeperSwitch.addTarget(self, action: "runkeeperSwitchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    view!.addSubview(runkeeperSwitch)

    runkeeperSwitch.snp_makeConstraints { (make) -> Void in
      make.width.equalTo(200)
      make.height.equalTo(30)
      make.centerY.equalTo(self.titleLabel.snp_centerY)
      make.left.equalTo(self.view!.snp_left).offset(15)
    }
  }

  func setSwitchToIndex(index:Int) {
    runkeeperSwitch.setSelectedIndex(index, animated: true)
  }

  @objc private func runkeeperSwitchValueChanged() {
    delegate?.homeNavBar(NavBar: self, didSelecectedAtIndex: runkeeperSwitch.selectedIndex)
  }

}