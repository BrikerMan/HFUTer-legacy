//
//  InfoJobsViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/24.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import MJRefresh

class InfoJobsViewController: EEBaseViewController {
  
  private var modelList = [InfoJobModel]()
  private var page = 1
  private var isRequestGoing = false
  
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nib = UINib(nibName: "InfoJobsListTableViewCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "InfoJobsListTableViewCell")
    
    tableView.rowHeight = 80
    tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
    
    tableView.mj_header = MJRefreshHeader(refreshingBlock: { () -> Void in
      if !self.isRequestGoing {
        self.page = 1
        self.modelList.removeAll()
        self.getJobsForPage()
      }
    })
    
    tableView.mj_footer = MJRefreshFooter(refreshingBlock: { () -> Void in
      if !self.isRequestGoing {
        self.page += 1
        self.getJobsForPage()
      }
    })
    
    self.tableView.mj_header.beginRefreshing()
    Hud.showLoading("正在加载")
  }
  
  private func getJobsForPage() {
    isRequestGoing = true
    let operation = InfoGetJobListRequest()
    operation.get(page,
      complitionBlock: { (modelList) -> () in
        self.modelList.appendContentsOf(modelList)
        self.tableView.reloadData()
        self.isRequestGoing = false
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
        Hud.dismiss()
      }, failedBlock: { (error) -> () in
        self.isRequestGoing = false
        Hud.showError(error)
      }, netErrorBlock: { () -> () in
        self.isRequestGoing = false
        Hud.showError(NetErrorWarning)
    })
  }
}

extension InfoJobsViewController:UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let vc = InfoJobDetailViewController()
    vc.model = modelList[indexPath.row]
    self.pushToViewController(vc)
  }
}

extension InfoJobsViewController:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return modelList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("InfoJobsListTableViewCell", forIndexPath: indexPath) as! InfoJobsListTableViewCell
    cell.setupWithModel(modelList[indexPath.row])
    return cell
  }
}
