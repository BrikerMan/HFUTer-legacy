//
//  HDImageView.swift
//  Hande
//
//  Created by Eliyar Eziz on 15/11/13.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import YYWebImage

class EEImageView: UIImageView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialImageView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialImageView()
  }
  
  private func initialImageView() {
    self.clipsToBounds = true
    self.contentMode = .ScaleAspectFill
    self.backgroundColor = UIColor ( red: 0.8667, green: 0.8667, blue: 0.8667, alpha: 1.0 )
  }
  
  func loadImageFromUrl(url:String?) {
    if let url = url, link = NSURL(string: url) {
      self.yy_setImageWithURL(link, options: YYWebImageOptions.Progressive)
    }
  }
}
