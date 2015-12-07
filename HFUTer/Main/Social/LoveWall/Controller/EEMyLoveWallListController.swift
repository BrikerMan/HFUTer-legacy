//
//  EEMyLoveWallListController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/4.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class EEMyLoveWallListController: EEBaseViewController {
  
  var modelsList = [EECommunityLoveWallModel]()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nib = UINib(nibName: "EEMyLoveWallListCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "EEMyLoveWallListCell")
    
    self.view.backgroundColor = Color.getGradientColor()
    tableView.backgroundColor = UIColor.clearColor()
  
    navTitle = "我的表白"
    
    getModelsForPage()
  }
  

  private func deleteLoveWall(index:Int) {
    Hud.showLoading("正在删除")
    modelsList[index].deleteModel { (succes, error) -> () in
      if succes {
        Hud.dismiss()
        self.modelsList.removeAtIndex(index)
        self.tableView.reloadData()
      } else {
        Hud.showError(error)
      }
    }
  }
  
  private func getModelsForPage() {
    Hud.showLoading("正在加载")
    EECommunityLoveWallModel.getModelsFromNetWorkForMineListForPage(0) { (error, models) -> () in
      if let models = models {
        self.modelsList = models
        self.tableView.reloadData()
        Hud.dismiss()
      } else {
        Hud.showError(error)
      }
    }
  }
}

extension EEMyLoveWallListController:UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let vc = BCLoveWallDetailViewController(nibName:"BCLoveWallDetailViewController",bundle:nil)
    vc.model = self.modelsList[indexPath.row]
    self.pushToViewController(vc)
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return EEMyLoveWallListCell.heightForModel(modelsList[indexPath.row])
  }
}

extension EEMyLoveWallListController:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return modelsList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EEMyLoveWallListCell", forIndexPath: indexPath) as! EEMyLoveWallListCell
    cell.setupWithModel(modelsList[indexPath.row])
    cell.actionBlock = {
      self.deleteLoveWall(indexPath.row)
    }
    return cell
  }
}
