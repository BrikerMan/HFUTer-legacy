//
//  InfoCourseFeeViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/25.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class InfoCourseFeeViewController: EEBaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var courseFeeList = [CourseFeeModel]()
  private var corseFeeListBySemester = [[CourseFeeModel]]()
  private var semesterFeeList = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "收费查询"
    let nib = UINib(nibName: "BCCourseFeeTableViewCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "BCCourseFeeTableViewCell")
    
    getCourseFeeRequest()
  }
  
  
  private func getCourseFeeRequest() {
    Hud.showLoading("正在加载收费详情")
    let operation = BCGetCourseFeeRequest()
    operation.getRequest(
      { (CourseFeeList, semesterList) -> Void in
        self.courseFeeList = CourseFeeList
        self.corseFeeListBySemester = CourseFeeModel.readFeesBySemester(CourseFeeList)
        self.semesterFeeList = semesterList
        self.tableView.reloadData()
        Hud.dismiss()
      }, onFailedBlock: { () -> Void in
        Hud.showError("加载失败，请稍候再试")
      }) { () -> Void in
        Hud.showError(NetErrorWarning)
    }
  }
}


private typealias tableViewDataSourse = InfoCourseFeeViewController
extension tableViewDataSourse:UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if courseFeeList.count > 0 {
      return corseFeeListBySemester.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if courseFeeList.count > 0 {
      return corseFeeListBySemester[section].count
    } else {
      return 0
    }
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BCCourseFeeTableViewCell", forIndexPath: indexPath) as! BCCourseFeeTableViewCell
    cell.setupWithModel(corseFeeListBySemester[indexPath.section][indexPath.row])
    return cell
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = BCCourseFeeTableViewHeader()
    if !corseFeeListBySemester[section].isEmpty{
      view.setupTitle(corseFeeListBySemester[section][0].semester, detail: semesterFeeList[section])
    }
    return view
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 70
  }
  
}

private typealias tableViewDelegate = InfoCourseFeeViewController
extension tableViewDelegate:UITableViewDelegate {

}