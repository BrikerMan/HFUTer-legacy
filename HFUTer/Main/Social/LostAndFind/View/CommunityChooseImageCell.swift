//
//  CommunityChooseImageCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/26.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

//!!NextVersion:替换图片选择
public class CommunityChooseImageCell:Cell<UIImage>, CellType{
  
  @IBOutlet weak var image1: UIImageView!
  @IBOutlet weak var image2: UIImageView!
  @IBOutlet weak var image3: UIImageView!
  
  @IBAction func onImage1Pressed(sender: AnyObject) {
  }
  
}

