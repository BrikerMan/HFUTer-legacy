//
//  EEMyPublishedListController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/3.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import ChameleonFramework

class EEMyPublishedListController: EEBaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var models = [EECommunityMyPublishesLostAndFoundModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "我的发布"
    self.view.layoutIfNeeded()
    self.view.backgroundColor = Color.getGradientColor()
    self.tableView.backgroundColor = UIColor.clearColor()
    let nib = UINib(nibName: "EEMyPublishedLostListTableViewCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "EEMyPublishedLostListTableViewCell")
    
    getDataForPage()
  }
  
  private func getDataForPage() {
    EECommunityMyPublishesLostAndFoundModel.getModelsFromNetWorkForPage(0) { (error, models) -> () in
      if let models = models {
        self.models = models
        self.tableView.reloadData()
      }
    }
  }
  
  private func markAsFinished(index:Int) {
    let model = models[index]
    Hud.showLoading("正在标记结束")
    model.markAsFinished { (error, model) -> () in
      if let model = model {
        self.models[index] = model
        self.tableView.reloadData()
        Hud.dismiss()
      } else {
        Hud.showError(error)
      }
    }
  }
}



extension EEMyPublishedListController:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.models.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EEMyPublishedLostListTableViewCell", forIndexPath: indexPath) as! EEMyPublishedLostListTableViewCell
    cell.setupWithModel(models[indexPath.row],index:indexPath.row)
    cell.clickedBlock = { (index) in
      self.markAsFinished(index)
    }
    return cell
  }
}

extension EEMyPublishedListController:UITableViewDelegate {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return EEMyPublishedLostListTableViewCell.heightForModel(models[indexPath.row])
  }
}