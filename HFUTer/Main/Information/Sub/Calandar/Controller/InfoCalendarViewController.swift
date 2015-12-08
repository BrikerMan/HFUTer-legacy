//
//  InfoCalendarViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/7.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit

class InfoCalendarViewController: EEBaseViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  private var calanarImage = UIImage()
  var schoolYark = "HF"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "校历"
    if schoolYark == "HF" {
      calanarImage = UIImage(named: "hf_calendar")!
    } else  {
      calanarImage = UIImage(named: "xc_calendar")!
    }
    initScrollView()
  }
  
  
  private func initScrollView() {
    let height = (ScreenWidth * calanarImage.size.height)/calanarImage.size.width
    
    let contentView = UIView()
    self.scrollView.addSubview(contentView)
    
    contentView.snp_makeConstraints { (make) -> Void in
      make.edges.equalTo(self.scrollView)
    }
    
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFill
    imageView.image = calanarImage
    contentView.addSubview(imageView)
    
    imageView.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(contentView.snp_top)
      make.left.equalTo(contentView.snp_left)
      make.width.equalTo(ScreenWidth)
      make.height.equalTo(height)
    }
    
    contentView.snp_updateConstraints { (make) -> Void in
      make.right.equalTo(imageView.snp_right)
      make.height.equalTo(imageView.snp_height)
    }
  }
  
}
