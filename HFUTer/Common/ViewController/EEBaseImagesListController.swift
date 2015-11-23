//
//  EEBaseImagesListViewViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/23.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit

enum EEBaseImagesListControllerDataSource {
  case Image
  case Link
}

protocol EEBaseImagesListControllerDelegate {
  func didDeletedImageAtIndex(index:Int)
}

class EEBaseImagesListController: EEBaseViewController {
  
  var delegate:EEBaseImagesListControllerDelegate?
  var page = 0
  var images = [UIImage]()
  var imageLinks = [String]()
  var isEditMode = false
  
  private var dataSource = EEBaseImagesListControllerDataSource.Link
  
  private var scrollView:UIScrollView!
  private var contentView:UIView!
  private var imageCount = 0
  
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(style:EEBaseImagesListControllerDataSource) {
    self.init()
    self.dataSource = style
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initSctollView()
    initalWithImages()
    fixUI()
    showCurrentPage()
    navTitle = ("\(page+1)/\(imageCount)")
  }

  private func showCurrentPage() {
    scrollView.setContentOffset(CGPointMake(CGFloat(page) * ScreenWidth, 0), animated: false)
  }
  
  private func initSctollView() {
    scrollView = UIScrollView()
    scrollView.minimumZoomScale = 0.1
    scrollView.maximumZoomScale = 4.0
    //    scrollView.zoomScale = 1.0
    scrollView.backgroundColor = Color.primaryDarkColor
    scrollView.delegate = self
    scrollView.pagingEnabled = true
    scrollView.showsHorizontalScrollIndicator = false
    view.addSubview(scrollView)
    
    scrollView.snp_makeConstraints { (make) -> Void in
      make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
    }
    
    contentView = UIView()
    scrollView.addSubview(contentView)
    
    contentView.snp_makeConstraints { (make) -> Void in
      make.edges.equalTo(scrollView)
    }
  }
  
  private func initalWithImages() {
    if dataSource == .Image {
      imageCount = images.count
    } else {
      imageCount = imageLinks.count
    }
    for i in 0..<imageCount {
      let imageView = EEImageView(frame:CGRectZero)
      imageView.contentMode =  UIViewContentMode.ScaleAspectFit
      imageView.backgroundColor = Color.primaryDarkColor
      
      contentView.addSubview(imageView)
      
      imageView.snp_makeConstraints { (make) -> Void in
        make.top.equalTo(contentView.snp_top)
        make.left.equalTo(contentView.snp_left).offset(CGFloat(i)*ScreenWidth)
        make.height.equalTo(ScreenHeight - 64)
        make.width.equalTo(ScreenWidth)
      }
      
      if dataSource == .Image {
        imageView.image = images[i]
      } else {
        imageView.loadLostImageWithPicName(imageLinks[i])
      }
    }
    
    contentView.snp_updateConstraints { (make) -> Void in
      make.width.equalTo(ScreenWidth * CGFloat(imageCount))
      make.height.equalTo(ScreenWidth - 64)
    }
    
    self.view.layoutIfNeeded()
    //    let x = CGFloat(page)*SCREENWIDTH
    //    scrollView.scrollRectToVisible(CGRectMake(x, 0, SCREENWIDTH, SCREENHEIGHT-64), animated: false)
  }
  
  private func fixUI() {
    if isEditMode {
      self.showNavRightButtonWithIcon("")
    }
  }
  
  override func onRightNavButtonPress() {
    delegate?.didDeletedImageAtIndex(page)
    self.pop()
  }
}

private typealias scrollViewDelegate = EEBaseImagesListController
extension scrollViewDelegate:UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if scrollView.contentOffset.x < -35 {
      self.pop()
    }
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    self.page = Int(scrollView.contentOffset.x/ScreenWidth)
    navTitle = "\(page+1)/\(imageCount)"
  }
}
