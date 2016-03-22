//
//  BCMassageLoveWallView.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/24.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import MJRefresh

protocol BCMassageLoveWallViewDelegate {
  func LoveWallViewRefresh()
  func LoveWallViewLoadMore()
  
  func LoveWallViewLikeButtonPressed(index:Int)
  func LoveWallViewCommmentButtonPress(index:Int)
  
  func LoveWallViewSelectedAtCell(index:Int)
}

class BCMassageLoveWallView: EEXibView {
  
  @IBOutlet weak var tableView: UITableView!
  var selectedCell = EELoveWallTableCell()
  var delegate:BCMassageLoveWallViewDelegate?
  
  private var modelList = [EECommunityLoveWallModel]()
  override func initFromXib() {
    super.initFromXib()
    self.tableView.backgroundColor = Color.getGradientColor()
    self.view?.backgroundColor = UIColor.clearColor()
    let nib = UINib(nibName: "EELoveWallTableCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "EELoveWallTableCell")
    
    self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
      self.delegate?.LoveWallViewRefresh()
    })
    
    self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
      self.delegate?.LoveWallViewLoadMore()
    })
    
  }
  
  func iniModelList(modelList:[EECommunityLoveWallModel]) {
    self.tableView.mj_header.endRefreshing()
    self.modelList = modelList
    self.tableView.reloadData()
  }
  
  func startLoadingAnimation() {
    self.tableView.mj_header.beginRefreshing()
  }
  
  func endLoadMoreRefreshing(isMore:Bool) {
    if isMore {
      self.tableView.mj_footer.endRefreshing()
    } else {
      self.tableView.mj_footer.endRefreshingWithNoMoreData()
    }
    self.tableView.mj_header.endRefreshing()
  }
  
  override func changeTintColor(notification: NSNotification?) {
    super.changeTintColor(notification)
    if let cells = tableView.visibleCells as? [BCMassageLoveTableViewCell] {
      for cell in cells {
        cell.colorfulBackView.backgroundColor  = Color.secondaryTintColor
        cell.colorfulBaclView2.backgroundColor = Color.secondaryTintColor
      }
    }
  }
}


private typealias tableViewDataSourse = BCMassageLoveWallView
extension tableViewDataSourse:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return modelList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EELoveWallTableCell", forIndexPath: indexPath) as! EELoveWallTableCell
    cell.setupWithModel(modelList[indexPath.row],index:indexPath.row)
    cell.selectionStyle = .None
    return cell
  }
}

private typealias tableViewDelegate = BCMassageLoveWallView
extension tableViewDelegate:UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! EELoveWallTableCell
    delegate?.LoveWallViewSelectedAtCell(indexPath.row)
  }
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return BCMassageLoveTableViewCell.getHeightForModel(modelList[indexPath.row])
  }
}
