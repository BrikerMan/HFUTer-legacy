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
    self.view.layoutIfNeeded()
    self.view.backgroundColor = Color.getGradientColor()
    self.tableView.backgroundColor = UIColor.clearColor()
//      Color.primaryTintColor.ultraLight()
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
  
  
}



extension EEMyPublishedListController:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.models.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EEMyPublishedLostListTableViewCell", forIndexPath: indexPath) as! EEMyPublishedLostListTableViewCell
    cell.setupWithModel(models[indexPath.row])
    return cell
    return UITableViewCell()
  }
}

extension EEMyPublishedListController:UITableViewDelegate {
  
}