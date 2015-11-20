//
//  BCShcedulesWeekEditView.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/9.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCShcedulesWeekEditView:EEXibView {
  
  var dissmissBlock:(([Int])->())?
  var weekList = [Int]() {
    didSet {
      tempWeekList = weekList
    }
  }
  
  private var tempWeekList = [Int]()
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBAction func onDoneButtonPress(sender: AnyObject) {
    weekList = tempWeekList
    dissmissBlock?(weekList)
  }
  
  override func initFromXib() {
    super.initFromXib()
    let nib = UINib(nibName: "BCShcedulesWeekEditViewCell", bundle: nil)
    collectionView.registerNib(nib, forCellWithReuseIdentifier: "BCShcedulesWeekEditViewCell")
    collectionView.scrollEnabled = false
  }
}



private typealias collectionViewLayout = BCShcedulesWeekEditView
extension collectionViewLayout:UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width:CGFloat = (ScreenWidth-27)/5
    return CGSizeMake(width, 30)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    
    return UIEdgeInsetsMake(1, 1, 0, 1)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 1
  }
}

private typealias collectionViewDataSource = BCShcedulesWeekEditView
extension collectionViewDataSource:UICollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 25
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BCShcedulesWeekEditViewCell", forIndexPath: indexPath) as! BCShcedulesWeekEditViewCell
    
    cell.weekSelected = weekList.contains(indexPath.row + 1) ? true : false
    
    cell.index = indexPath.row + 1
    return cell
  }
}

private typealias collectionViewDelegate = BCShcedulesWeekEditView
extension collectionViewDelegate:UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BCShcedulesWeekEditViewCell
    cell.weekSelected = !cell.weekSelected
    if cell.weekSelected {
      self.tempWeekList.append(indexPath.row + 1)
    } else {
      let removeIndex = self.tempWeekList.indexOf(indexPath.row + 1)
      self.tempWeekList.removeAtIndex(removeIndex!)
    }
  }
}