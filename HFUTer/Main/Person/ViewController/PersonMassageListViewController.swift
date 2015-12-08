//
//  PersonMassageListViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import MJRefresh

class PersonMassageListViewController: EEBaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var models = [EECommunityMassageModel]()
  private var massagePage = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "我的消息"
    
    let nib = UINib(nibName: "PersonMassageTableViewCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "PersonMassageTableViewCell")
    
    self.view.backgroundColor = Color.getGradientColor()
    tableView.backgroundColor = UIColor.clearColor()
    
    tableView.mj_header = MJRefreshHeader(refreshingBlock: { () -> Void in
      self.models.removeAll()
      self.massagePage = 0
      self.loadMassageForPage()
    })
    
    tableView.mj_footer = MJRefreshFooter(refreshingBlock: { () -> Void in
      self.massagePage += 1
      self.loadMassageForPage()
    })
    self.tableView.mj_header.beginRefreshing()
    
  }
  
  
  func loadMassageForPage() {
    Hud.showLoading("正在加载")
    EECommunityMassageModel.getListFromServer(0, page: massagePage) {
      (error, models) -> () in
      if let models = models {
        self.models += models
        self.tableView.reloadData()
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
        Hud.dismiss()
      } else {
        Hud.showError(error)
      }
    }
  }
}


extension PersonMassageListViewController:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PersonMassageTableViewCell", forIndexPath: indexPath) as! PersonMassageTableViewCell
    cell.setupWithModel(models[indexPath.row])
    return cell
  }
}

extension PersonMassageListViewController:UITableViewDelegate {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return PersonMassageTableViewCell.getHeightFormModel(models[indexPath.row])
  }
}