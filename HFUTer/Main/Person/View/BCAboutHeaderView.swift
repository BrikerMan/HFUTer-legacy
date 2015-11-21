//
//  BCAboutHeaderView.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/16.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCAboutHeaderView : UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = CGRect(x: 0, y: 0, width: 320, height: 130)
    initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initView()
  }
  
  private func initView() {
    let logoLabel = UILabel()
    logoLabel.font = UIFont.systemFontOfSize(34)
    logoLabel.text = "HFUTer"
    logoLabel.textAlignment = .Center
    logoLabel.textColor = UIColor ( red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0 )
    self.addSubview(logoLabel)
    
    logoLabel.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(self.snp_top).offset(20)
      make.centerX.equalTo(self.snp_centerX)
    }
    
    let detailLabel =  UILabel()
    detailLabel.font = UIFont.systemFontOfSize(12)
    detailLabel.text = "V 1.5\n ©2015 https://eliyar.biz\nQQ群：117196247"
    detailLabel.textAlignment = .Center
    detailLabel.numberOfLines = 0
    detailLabel.textColor = UIColor ( red: 0.3258, green: 0.3258, blue: 0.3258, alpha: 1.0 )
    self.addSubview(detailLabel)
    
    detailLabel.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(logoLabel.snp_bottom).offset(8)
      make.centerX.equalTo(self.snp_centerX)
    }
  }
}