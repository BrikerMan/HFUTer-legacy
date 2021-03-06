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
  
  private let cellTitleAndImageList = [
    ("校园新闻","info_news"),
    ("兼职信息","info_jobs"),
    ("教学班查询","info_class"),
    ("收费查询","info_fee"),
    ("借阅查询","info_books"),
    ("校历查询","info_calendar")
  ]
  
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
    return 6
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
      let vc = InfoNewsCategoriesViewController(nib: "InfoNewsCategoriesViewController")
      self.pushToViewController(vc)
		log.eventForCategoty(eventName: "查看校园新闻分类", category: .Info)
    case 1:
      let vc = InfoJobsViewController(nib: "InfoJobsViewController")
      self.pushToViewController(vc)
		log.eventForCategoty(eventName: "查看兼职信息列表", category: .Info)
    case 2:
      runAfterLoginToEdu({ () -> () in
        let vc = InfoCourseListViewController(nib:"InfoCourseListViewController")
        self.pushToViewController(vc)
		log.eventForCategoty(eventName: "查看教学班查询列表", category: .Info)
      })
    case 3:
      runAfterLoginToEdu({ () -> () in
        let vc = InfoCourseFeeViewController(nib:"InfoCourseFeeViewController")
        self.pushToViewController(vc)
		log.eventForCategoty(eventName: "查看收费信息", category: .Info)
      })
    case 4:
      Hud.showError("暂未开放")
      //      let vc = InfoBookListViewController(nib: "InfoBookListViewController")
      //      self.pushToViewController(vc)
		log.eventForCategoty(eventName: "查看借阅情况", category: .Info)
    case 5:
      if DataEnv.eduUser.isLogin {
        let vc = InfoCalendarViewController(nib:"InfoCalendarViewController")
        vc.schoolYark = DataEnv.eduUser.schoolYard
        self.pushToViewController(vc)
      } else {
        let actionSheet = UIActionSheet()
        actionSheet.title = "请选择校区"
        actionSheet.addButtonWithTitle("合肥校区")
        actionSheet.addButtonWithTitle("宣城校区")
        actionSheet.addButtonWithTitle("取消")
        actionSheet.cancelButtonIndex = 2
        actionSheet.delegate = self
        actionSheet.showInView(self.view)
      }
		log.eventForCategoty(eventName: "查看校历", category: .Info)
    default:
      break
    }
  }
}

//MARK: - 校园选择
extension InformationViewController:UIActionSheetDelegate {
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == 2 { return }
    
    let vc = InfoCalendarViewController(nib:"InfoCalendarViewController")
    if buttonIndex == 0 {
      vc.schoolYark = "HF"
    } else if buttonIndex == 1{
      vc.schoolYark = "XC"
    }
    self.pushToViewController(vc)
  }
}