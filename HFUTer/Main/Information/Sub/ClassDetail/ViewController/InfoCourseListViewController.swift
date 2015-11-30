//
//  InfoCourseDetailViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/25.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class InfoCourseListViewController: EEBaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var classList = [ClassListModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "教学班列表"
    
    let footer = UIView()
    tableView.tableFooterView = footer
    
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
    tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
    beginGetClassListRquest()
  }

  private func beginGetClassListRquest() {
    Hud.showLoading("正在加载教学班列表")
    let operation = BCGetClassListRequest()
    operation.getRequest({ () -> Void in
      self.classList = operation.classListModels
      self.tableView.hidden = false
      self.tableView.reloadData()
      Hud.dismiss()
      }, onFailedBlock: { () -> Void in
        Hud.showError("加载错误，请稍候再试")
      }) { () -> Void in
        Hud.showError(NetErrorWarning)
    }
  }
}


extension InfoCourseListViewController:UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let vc = InfoCourseDetailViewController(nib: "InfoCourseDetailViewController")
    vc.model = self.classList[indexPath.row]
    self.pushToViewController(vc)
  }
}

extension InfoCourseListViewController:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.classList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath: indexPath)
    cell.accessoryType = .DisclosureIndicator
    cell.textLabel?.text = self.classList[indexPath.row].name
    return cell
  }
}


