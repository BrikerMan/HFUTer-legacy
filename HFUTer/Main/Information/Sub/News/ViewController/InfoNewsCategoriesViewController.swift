//
//  InfoNewsCategoriesViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/23.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class InfoNewsCategoriesViewController: EEBaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var newsCategories = [NewsCategories]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "新闻列表"
    newsCategories = NewsCategories.get()
    
    let footer = UIView()
    tableView.tableFooterView = footer
    
    tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
}

extension InfoNewsCategoriesViewController:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newsCategories.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    cell.textLabel?.text = newsCategories[indexPath.row].title
    cell.textLabel?.textColor = UIColor ( red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0 )
    cell.accessoryType = .DisclosureIndicator
    return cell
  }
}

extension InfoNewsCategoriesViewController:UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let vc = InfoNewsListViewController(nib: "InfoNewsListViewController")
    vc.setupNewsCategoryModel(newsCategories[indexPath.row])
    self.pushToViewController(vc)
  }
}