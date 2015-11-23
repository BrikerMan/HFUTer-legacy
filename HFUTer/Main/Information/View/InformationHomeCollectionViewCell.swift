//
//  InformationHomeCollectionViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/23.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class InformationHomeCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
   
  }
  
  func setTitleAndImage(title:String,image:String) {
    titleLabel.text = title
    
  }
}
