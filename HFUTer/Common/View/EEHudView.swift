//
//  HHHudView.swift
//  handebiao
//
//  Created by Eliyar Eziz on 15/11/10.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import WSProgressHUD

private let _SingletonASharedInstance = EEHudView()

class EEHudView {
  
  private typealias hud = WSProgressHUD
  //单例
  class func sharedManager() -> EEHudView {
    return _SingletonASharedInstance
  }
  
  func showMassage(massage:String) {
    hud.showShimmeringString(massage)
    delay(seconds: 2) { () -> () in
      hud.dismiss()
    }
  }
  
  func showLoading(massage:String){
    hud.showShimmeringString(massage)
  }
  
  func showLoadingWithMask(massage:String) {
    hud.showShimmeringString(massage, maskType: WSProgressHUDMaskType.Black)
  }
  
  func showError(massage:String?) {
    hud.showShimmeringString(massage ?? "未知错误")
    delay(seconds: 2) { () -> () in
      hud.dismiss()
    }
  }
  
  func dismiss() {
    hud.dismiss()
  }
}