//
//  InfoNewsListViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/23.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class InfoNewsListViewController: EEBaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var newsCategoryModel = NewsCategories()
  private var newsListModelList = [NewsListModel]()
  private var isGetNewsListRequestGoing = false

  
  override func viewDidLoad() {
    super.viewDidLoad()
    let nib = UINib(nibName: "NewsListTableViewCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "NewsListTableViewCell")
    getNewsListRequest()
  }
  
  func setupNewsCategoryModel(model:NewsCategories) {
    self.newsCategoryModel = model
    self.navTitle = model.title
  }
  
  private func getNewsListRequest() {
    if !isGetNewsListRequestGoing {
      isGetNewsListRequestGoing = true
      
      let url = "http://hfut.cn-hangzhou.aliapp.com/news/newsList"
      let params:[String:AnyObject] = [
        "pageIndex":"1",
        "pageSize":"40",
        "type":self.newsCategoryModel.type]
      
      Hud.showLoading("正在加载")
      BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
        onFinishedBlock: { (response) -> Void in
          Hud.dismiss()
          let json = JSONND.init(dictionary:response as! [String : AnyObject])
          if let array = json["data"].array {
            for json in array {
              let model = NewsListModel(JSONNDObject: json)
              self.newsListModelList.append(model)
            }
          }
          self.tableView.reloadData()
        }, onFailedBlock: { (reason) -> Void in
          Hud.showError(reason)
        }, onNetErrorBlock: { () -> Void in
          Hud.showError(NetErrorWarning)
      })
    }
  }
}

//MARK:- UITableViewDataSource
extension InfoNewsListViewController:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newsListModelList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("NewsListTableViewCell", forIndexPath: indexPath) as! NewsListTableViewCell
    cell.setModel(newsListModelList[indexPath.row])
    return cell
  }
}


extension InfoNewsListViewController:UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    newsListModelList[indexPath.row].hasRead = true
    self.tableView.reloadData()
    let vc = InfoNewsDetailViewController()
    vc.passNewsModel(newsListModelList[indexPath.row])
    self.pushToViewController(vc)
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return NewsListTableViewCell.getHighForModel(newsListModelList[indexPath.row])
  }
}