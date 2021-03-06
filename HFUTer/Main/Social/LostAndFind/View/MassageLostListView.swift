//
//  MassageLostListView.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/10.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import MJRefresh

protocol MassageLostListViewDelegate {
  func MassageLostListRefresh()
  func MassageLostListLoadMore()
  
  func MassageLostListReplyButtonPressed(index:Int)
  func MassageLostListImagesPressed(imageLinks: [String],index:Int)
}
class MassageLostListView: EEXibView {
  
  @IBOutlet weak var tableView: UITableView!
  var delegate : MassageLostListViewDelegate?
  private var modelList = [BCLostAndFoundModel]()
  
  override func initFromXib() {
    super.initFromXib()
    
    let newNib = UINib(nibName: "EEMessageTableViewCell", bundle: nil)
    tableView.registerNib(newNib, forCellReuseIdentifier: "EEMessageTableViewCell")
    
    tableView.backgroundColor = UIColor.clearColor()
    self.view?.backgroundColor = UIColor.clearColor()
    self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
      self.delegate?.MassageLostListRefresh()
    })
    
    self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
      self.delegate?.MassageLostListLoadMore()
    })
  }
  
  func initModelList(modelList:[BCLostAndFoundModel]) {
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
    
  }
}

private typealias massageLostTableViewCellDelegate = MassageLostListView
extension massageLostTableViewCellDelegate: EEMessageTableViewCellDelegate {
  func onReplyButtonPress(index:Int) {
    delegate?.MassageLostListReplyButtonPressed(index)
  }
  
  func MassageLostListImagesPressed(imageLinks: [String],index:Int) {
    delegate?.MassageLostListImagesPressed(imageLinks,index:index)
  }
}

private typealias tableViewDataSourse = MassageLostListView
extension tableViewDataSourse:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return modelList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EEMessageTableViewCell", forIndexPath: indexPath) as! EEMessageTableViewCell
    cell.delegate = self
    cell.setModel(modelList[indexPath.row],index:indexPath.row)
    return cell
  }
}

private typealias tableViewDelegate = MassageLostListView
extension tableViewDelegate:UITableViewDelegate {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//    return MassageLostTableViewCell.getHeightForModel(modelList[indexPath.row])
    return EEMessageTableViewCell.getHeight(forModel: modelList[indexPath.row])
  }
}


