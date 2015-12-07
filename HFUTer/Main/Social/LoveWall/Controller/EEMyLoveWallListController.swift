//
//  EEMyLoveWallListController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/4.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class EEMyLoveWallListController: EEBaseViewController {
  
  let modelsList = [EECommunityLoveWallModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getModelsForPage()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  private func getModelsForPage() {
    Hud.showLoading("正在加载")
    EECommunityLoveWallModel.getModelsFromNetWorkForPage(0) { (error, models) -> () in
      if let models = models {
        Hud.dismiss()
      } else {
        Hud.showError(error)
      }
    }
  }
}
