//
//  BCShcedulesWeekEditViewCell.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/9.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCShcedulesWeekEditViewCell: UICollectionViewCell {
  
  @IBOutlet weak var weekId: UILabel!
  
  var index = 0 {
    didSet {
      weekId.text = "\(index)"
    }
  }
  
  var weekSelected = false {
    didSet {
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.backgroundColor = self.weekSelected ? Color.primaryTintColor : UIColor.whiteColor()
      })
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
