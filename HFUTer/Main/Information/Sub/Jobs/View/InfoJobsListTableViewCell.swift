//
//  InfoJobsListTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/24.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class InfoJobsListTableViewCell: UITableViewCell {
  
  private var model = InfoJobModel()
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var schoolYard: UILabel!
  @IBOutlet weak var peopleName: UILabel!
  @IBOutlet weak var time: UILabel!
  @IBOutlet weak var limit: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.accessoryType = .DisclosureIndicator
  }
  
  
  func setupWithModel(model:InfoJobModel) {
    self.model = model
    
    titleLabel.text = model.name
    schoolYard.text = "校区：\(model.schoolyard)"
    peopleName.text = "报名人数：\(model.personNum)"
    time.text       = "发布时间：\(model.time)"
    limit.text      = "校区：\(model.limit)"
    fixUI()
  }
  
  private func fixUI() {
    let lightColor = (model.status == "正在报名") ? UIColor ( red: 0.3258, green: 0.3258, blue: 0.3258, alpha: 1.0 ):UIColor ( red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0 )
    let mainColor = (model.status == "正在报名") ? UIColor ( red: 0.1506, green: 0.1506, blue: 0.1506, alpha: 1.0 ):UIColor ( red: 0.5296, green: 0.5296, blue: 0.5296, alpha: 1.0 )
    
    titleLabel.textColor = mainColor
    schoolYard.textColor = lightColor
    peopleName.textColor = lightColor
    limit.textColor = lightColor
    time.textColor = lightColor
    
  }
  
}
