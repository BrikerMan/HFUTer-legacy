//
//  BCGradesTableView.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/9/14.
//  Copyright (c) 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCGradesTableView: UIView {
  
  private var tableView: UITableView = {
    let tableView = UITableView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49), style: UITableViewStyle.Grouped)
    tableView.backgroundColor = UIColor.whiteColor()
    
    tableView.rowHeight = 50
    tableView.allowsSelection = false
    let nib = UINib(nibName: "BCGradesTableViewCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "BCGradesTableViewCell")
    return tableView
  }()
  
  private var gradesBySemester = [[GradeModel]]()
  private var semesterList = [SemesterModel]()
  
  private var headerViewList = [BCGradeViewTableViewHeader]()
  
  var isSetUpData = false
  var refreshBlock:(() -> Void)?
  override init(frame: CGRect) {
    super.init(frame:frame)
    setUI()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    setUI()
  }
  
  private func setUI() {
    self.autoresizingMask = [.FlexibleHeight]
    self.backgroundColor = UIColor.whiteColor()
    self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
    
    tableView.dataSource = self
    tableView.delegate = self

    self.addSubview(tableView)
    
    }
  
  func reloadGrades() {
    self.isSetUpData = true
    self.gradesBySemester = GradeModel.getGradesBySemester()
    self.semesterList = GradeModel.calculateGPA()
    self.tableView.reloadData()
  }
  
  func changeTintColor() {
    for header in headerViewList {
      header.changeTintColor()
    }
  }
}

private typealias tableViewDataSourse = BCGradesTableView
extension tableViewDataSourse:UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if isSetUpData {
      return gradesBySemester.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isSetUpData {
      return gradesBySemester[section].count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BCGradesTableViewCell", forIndexPath: indexPath) as! BCGradesTableViewCell
    cell.setupWithModel(gradesBySemester[indexPath.section][indexPath.row])
    return cell
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = BCGradeViewTableViewHeader()
    header.setupWithSemester(semesterList[section])
    headerViewList.append(header)
    return header
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 54
  }
}

private typealias tableViewDelegate = BCGradesTableView
extension tableViewDelegate:UITableViewDelegate {
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.alpha = 0
    UIView.animateWithDuration(1.0) { () -> Void in
      cell.alpha = 1
    }
  }
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    view.alpha = 0
    UIView.animateWithDuration(1.0) { () -> Void in
      view.alpha = 1
    }
  }
  
  func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
    view.alpha = 0
    UIView.animateWithDuration(1.0) { () -> Void in
      view.alpha = 1
    }
  }
}

