//
//  PersonViewFooterView.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 16/1/12.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit

class PersonViewFooterView: UIView {
  
  private var infoLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initUI()
  }
  
  
  private func initUI() {
    infoLabel = UILabel()
    infoLabel.textColor = UIColor(hexString: "999999")
    infoLabel.font = UIFont.systemFontOfSize(12)
    infoLabel.textAlignment = .Center
    infoLabel.numberOfLines = 0
    
    self.addSubview(infoLabel)
  
    infoLabel.snp_makeConstraints { (make) -> Void in
      make.center.equalTo(self.snp_center)
      make.left.equalTo(self.snp_left).offset(10)
      make.right.equalTo(self.snp_right).offset(10)
    }
    
    if let version = getVersionString() {
      infoLabel.text = "V\(version)"
    } else {
      infoLabel.text = "V2.0"
    }
  }
  
}