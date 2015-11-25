//
//  InfoCourseDetailViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/25.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class InfoCourseDetailViewController: EEBaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var model:ClassListModel!
  private var studentList = [StudentModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navTitle = "教学班详情"
    
    let nib = UINib(nibName: "BCClassDetailTableViewCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "BCClassDetailTableViewCell")
    tableView.hidden = true
    
    getCourseDetailRequest()
  }
  
  
  private func getCourseDetailRequest() {
    
    Hud.showLoading("正在加载教学班详情")
    let operation = BCGetClassDetailRequest()
    let param = [
      "xqdm":XUEQIDAIMA,
      "kcdm":self.model.code,
      "jxbh":self.model.classNum,
      "button":"%B2%E9%D4%C4"
    ]
    operation.getReques(param,
      onFinishedBlock: { () -> Void in
        self.tableView.hidden = false
        self.studentList = operation.handledResult
        self.tableView.reloadData()
        Hud.dismiss()
      }) { () -> Void in
        Hud.showError(NetErrorWarning)
    }
  }
  
}


extension InfoCourseDetailViewController:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.studentList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BCClassDetailTableViewCell", forIndexPath: indexPath) as! BCClassDetailTableViewCell
    cell.setupWithModel(studentList[indexPath.row])
    return cell
  }
  
}

extension InfoCourseDetailViewController:UITableViewDelegate {
  
}