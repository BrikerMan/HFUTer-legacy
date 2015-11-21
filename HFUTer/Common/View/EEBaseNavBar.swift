//
//  EEBaseNavBar.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

enum EEBaseNavBarLeftButtonStyle {
  case None
  case Back
}

protocol EEBaseNavBarDelegate {
  func baseNavBarDidPressOnLeftButton(navBar:EEBaseNavBar)
}

class EEBaseNavBar: EEXibView {

  var delegate:EEBaseNavBarDelegate?
  var navLeftButtonStyle = EEBaseNavBarLeftButtonStyle.None {
    didSet {
      switch navLeftButtonStyle {
      case .None:
        navLeftButton.hidden = true
        navLeftImage.hidden  = true
      case .Back:
        navLeftButton.hidden = false
        navLeftImage.hidden  = false
      }
    }
  }

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var navLeftButton: UIButton!
  @IBOutlet weak var navLeftImage: UIImageView!


  override func initFromXib() {
    super.initFromXib()
    view?.backgroundColor = Color.primaryTintColor
    switch navLeftButtonStyle {
    case .None:
      navLeftButton.hidden = true
      navLeftImage.hidden  = true
    case .Back:
      navLeftButton.hidden = false
      navLeftImage.hidden  = false
    }

  }

  @IBAction func onNavLeftButtonPressed(sender: AnyObject) {
    delegate?.baseNavBarDidPressOnLeftButton(self)
  }
}
