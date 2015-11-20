//
//  BCScheduleSelectView.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/9.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCScheduleSelectViewCell:UITableViewCell {
  let titleLabel:UILabel = {
    let label = UILabel()
    label.textColor = UIColor ( red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0 )
    return label
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.addSubview(titleLabel)
    self.backgroundColor = UIColor.clearColor()
    titleLabel.snp_makeConstraints { (make) -> Void in
      make.center.equalTo(self.snp_center)
    }
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}

protocol BCScheduleSelectViewDelegate {
  func didSelectedOnWeek(week:Int)
}

class BCScheduleSelectView: EEXibView {

  var delegate:BCScheduleSelectViewDelegate?
  
  @IBOutlet weak var tableView: UITableView!
  
  override func initFromXib() {
    super.initFromXib()
    tableView.layer.cornerRadius = 3
    tableView.clipsToBounds = true
    tableView.registerClass(BCScheduleSelectViewCell.self, forCellReuseIdentifier: "BCScheduleSelectViewCell")
    tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: DataEnv.currentWeek, inSection: 0), atScrollPosition: UITableViewScrollPosition.Middle, animated: false)
  }
  
}

extension BCScheduleSelectView:UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 25
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BCScheduleSelectViewCell", forIndexPath: indexPath) as! BCScheduleSelectViewCell
    cell.titleLabel.text = "第\(indexPath.row + 1)周"
    return cell
  }
  
}

extension BCScheduleSelectView:UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    delegate?.didSelectedOnWeek(indexPath.row+1)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}
