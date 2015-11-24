//
//  InformationViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class InformationViewController: EEBaseViewController {
  
  @IBOutlet weak var collectiomView: UICollectionView!
  
  private let cellTitleAndImageList = [("校园新闻","info_news"),("兼职信息","info_jobs"),("教学班查询","info_class"),("收费查询","info_fee"),("借阅查询","info_books")]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "查询"
    self.collectiomView.backgroundColor = UIColor.groupTableViewBackgroundColor()
    let nib = UINib(nibName: "InformationHomeCollectionViewCell", bundle: nil)
    collectiomView.registerNib(nib, forCellWithReuseIdentifier: "InformationHomeCollectionViewCell")
  }
  
}

//MARK: - CollectionViewDataSource
extension InformationViewController:UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectiomView.dequeueReusableCellWithReuseIdentifier("InformationHomeCollectionViewCell", forIndexPath: indexPath) as! InformationHomeCollectionViewCell
    cell.setTitleAndImage(cellTitleAndImageList[indexPath.row].0, image: cellTitleAndImageList[indexPath.row].1)
    return cell
  }
}

//MARK: - CollectionViewDelegateFlowLayout
extension InformationViewController:UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width = (ScreenWidth - 3)/2
    return CGSizeMake(width, width-50)
  }
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(1, 1, 1, 1)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 1
  }
}

//MARK: - CollectionViewDelegate
extension InformationViewController:UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.row {
    case 0:
      let vc = InfoNewsCategoriesViewController()
      self.pushToViewController(vc)
    default:
      break
    }
  }
}