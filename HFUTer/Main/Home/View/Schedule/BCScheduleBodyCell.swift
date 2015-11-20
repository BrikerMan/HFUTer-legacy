//
//  BCScheduleBodyCell.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCScheduleBodyCell: UICollectionViewCell {
  
  @IBOutlet weak var classNameLabel: UILabel!
  @IBOutlet weak var classLocateLabel: UILabel!
  
  var models:[ScheduleModel]?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  
  func setupCellModels(models:[ScheduleModel]?) {
    if let models = models {
      self.models = models
      var className = ""
      var Place = ""
      let seperator = (models.count > 1) ? "/":""
      for model in models {
        className = model.name + seperator
        Place     = model.place + seperator
      }
      self.classNameLabel.text = className
      self.classLocateLabel.text = Place
      self.backgroundColor = Color.getRandomFlatColorForCode(models[0].name)
    } else {
      self.models = nil
      classNameLabel.text = ""
      classLocateLabel.text = ""
      self.backgroundColor = UIColor.whiteColor()
    }
  }
}
