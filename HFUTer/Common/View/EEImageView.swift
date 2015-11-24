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
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    if let url = url, link = NSURL(string: url) {
      self.yy_setImageWithURL(link, placeholder: nil, options: YYWebImageOptions.ProgressiveBlur, completion: { (image, link, from, stage, error) -> Void in
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      })
    }
  }
  
  
  func loadThumbnail(url:String) {
    let link = "http://7xlrpg.com1.z0.glb.clouddn.com/lost/" + url + "?imageView/2/w/200/format/jpg"
    self.loadImageFromUrl(link)
  }
  
  func loadAvatar(picName:String?) {
    if picName != nil && picName != "" {
      let link = "http://7xlrpg.com1.z0.glb.clouddn.com/icon/" + picName!
      self.loadImageFromUrl(link)
    } else {
      self.image = UIImage(named: "avatar")
    }
  }
  
  func loadLostImageWithPicName(picaName:String) {
    let link = "http://7xlrpg.com1.z0.glb.clouddn.com/lost/" + picaName
    self.loadImageFromUrl(link)
  }
  
}
