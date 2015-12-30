//
//  BCGradesTableView.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/9/14.
//  Copyright (c) 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import MJRefresh

class BCGradesTableView: UIView {
  
  private var tableView: UITableView = {
    let tableView = UITableView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49), style: UITableViewStyle.Grouped)
    tableView.backgroundColor = UIColor.whiteColor()
    
    tableView.rowHeight = 50
    tableView.allowsSelection = false
    
    let nib1 = UINib(nibName: "BCGradesHeaderCell", bundle: nil)
    tableView.registerNib(nib1, forCellReuseIdentifier: "BCGradesHeaderCell")
    
    let nib2 = UINib(nibName: "BCGradesTableViewCell", bundle: nil)
    tableView.registerNib(nib2, forCellReuseIdentifier: "BCGradesTableViewCell")
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
    
    tableView.mj_header = MJRefreshHeader(refreshingBlock: { () -> Void in
      self.refreshBlock?()
    })
    
    self.addSubview(tableView)
    
  }
  
  func reloadGrades() {
    self.isSetUpData = true
    self.gradesBySemester = GradeModel.getGradesBySemester()
    self.semesterList = GradeModel.calculateGPA()
    self.tableView.mj_header.endRefreshing()
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
      return gradesBySemester.count + 1
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isSetUpData {
      if section == 0 {
        return 1
      } else {
        return gradesBySemester[section - 1].count
      }
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("BCGradesHeaderCell", forIndexPath: indexPath) as! BCGradesHeaderCell
      cell.setAllGrades(GradeModel.calculateAllGPA())
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("BCGradesTableViewCell", forIndexPath: indexPath) as! BCGradesTableViewCell
      cell.setupWithModel(gradesBySemester[indexPath.section-1][indexPath.row])
      return cell
    }

  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      return nil
    } else {
      let header = BCGradeViewTableViewHeader()
      header.setupWithSemester(semesterList[section-1])
      headerViewList.append(header)
      return header
    }
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 { return 10 }
    return 54
  }
}

private typealias tableViewDelegate = BCGradesTableView
extension tableViewDelegate:UITableViewDelegate {
  
}

