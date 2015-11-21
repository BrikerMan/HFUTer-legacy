//
//  MassageMoreActionView.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/15.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol MassageMoreActionViewDelegate {
  func didSelectAtIndex(index:Int)
}

class MassageMoreActionView: EEXibView {

  var delegate:MassageMoreActionViewDelegate?
  
  override func initFromXib() {
    super.initFromXib()
    self.view?.backgroundColor = Color.primaryTintColor.light()
  }

  @IBAction func onILostThingsButtonPress(sender: AnyObject) {
    delegate?.didSelectAtIndex(0)
  }
  
  @IBAction func onIFoundThingsButtonPress(sender: AnyObject) {
    delegate?.didSelectAtIndex(1)
  }
  
  @IBAction func onMySendedMassagesButtonPressed(sender: AnyObject) {
    delegate?.didSelectAtIndex(2)
  }
  @IBAction func onContactLosterButtonPressed(sender: AnyObject) {
    delegate?.didSelectAtIndex(3)
  }
  @IBAction func onLoveWallButtonPressed(sender: AnyObject) {
    delegate?.didSelectAtIndex(4)
  }
  
  func changeTintColor() {
    self.view?.backgroundColor = Color.primaryTintColor.light()
  }
}
