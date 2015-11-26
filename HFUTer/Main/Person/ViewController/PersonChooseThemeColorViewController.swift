//
//  PersonChooseThemeColorViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/25.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import ChameleonFramework
class PersonChooseThemeColorViewController: EEBaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  private let colorDic = Color.colorDic
  
  var colorChoosedBlock:((choosedDic:(name:String,color:UIColor))->())?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
}


extension PersonChooseThemeColorViewController:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return colorDic.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    let ass = UIView(frame: CGRectMake(0,0,30,30))
    ass.layer.cornerRadius = 15
    ass.backgroundColor = colorDic[indexPath.row].color
    cell.accessoryView = ass
    cell.textLabel?.text = colorDic[indexPath.row].name
    return cell
  }
}

extension PersonChooseThemeColorViewController:UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    colorChoosedBlock?(choosedDic: colorDic[indexPath.row])
  }
}
