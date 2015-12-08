//
//  InfoCalendarViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/7.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class InfoCalendarViewController: EEBaseViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  private var calanarImage = UIImage()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "校历"
    if DataEnv.eduUser.schoolYard == "HF" {
      calanarImage = UIImage(named: "hf_calendar")!
    } else  {
      calanarImage = UIImage(named: "xc_calendar")!
    }
    initScrollView()
  }
  
  
  private func initScrollView() {
    let height = (ScreenWidth * calanarImage.size.height)/ScreenHeight
    self.scrollView.contentSize = CGSizeMake(ScreenWidth,height)
    
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFill
    imageView.image = calanarImage
    self.scrollView.addSubview(imageView)
    
    imageView.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(self.scrollView.snp_top)
      make.left.equalTo(self.scrollView.snp_left)
      make.right.equalTo(self.scrollView.snp_right)
      make.height.equalTo(height+200)
    }
  }
  
}
