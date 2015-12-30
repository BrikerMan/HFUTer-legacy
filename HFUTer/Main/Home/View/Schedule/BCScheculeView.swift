//
//  BCScheculeView.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import HMSegmentedControl
import MJRefresh

protocol BCScheculeViewDelegate {
  func didSelecctedAtCell(indexPath:NSIndexPath,models:[ScheduleModel]?)
}


class BCScheculeView: EEXibView {
  
  var delegate:BCScheculeViewDelegate?
  var refreshBlock:(()->Void)?
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var scheduleListForShow = [ScheduleModel]()
  private var scheduleDictForShow = [String:[ScheduleModel]]()
  
  private var dayNamesListOriginal = ["","周一","周二","周三","周四","周五","周六","周日"]
  private var dayNamesList = ["","","","","","",""]
  private var timeNamesList = ["","1-2","3-4","5-6","7-8","9-1","未安排课程"]
  
  private var week   = 0
  private var dayCount:CGFloat = 5
  private var leftCellWidth:CGFloat = 35
  //MARK:- 生命周期
  override func initFromXib() {
    super.initFromXib()
    collectionView.mj_header = MJRefreshHeader(refreshingBlock: { () -> Void in
      self.refreshBlock?()
    })
    
    registerCellAndPrepareView()
    week = DataEnv.currentWeek
    showCurrentWeeksSchedule(week)
    
  }
  
  //MARK:- 加载数据
  func showCurrentWeeksSchedule(week:Int?) {
    if let week = week {
      self.week = week
    }

    scheduleDictForShow.removeAll()
    scheduleListForShow = ScheduleModel.readScheduleModelForWeek(self.week)
    for schedule in scheduleListForShow {
      if let _ = scheduleDictForShow["\(schedule.hour)-\(schedule.day)"] {
        scheduleDictForShow["\(schedule.hour)-\(schedule.day)"]?.append(schedule)
      } else {
        scheduleDictForShow["\(schedule.hour)-\(schedule.day)"] = [schedule]
      }
    }
    collectionView.mj_header.endRefreshing()
    collectionView.reloadData()
  }
  
  
  //MARK:- 用户交互动作
  @objc private func segmentedControlChangedValue(sender:AnyObject?) {
    if let sender = sender as? HMSegmentedControl {
      let week = (sender.selectedSegmentIndex)
      self.showCurrentWeeksSchedule(week)
    }
  }
  
  func changeTintColor() {
    collectionView.backgroundColor = Color.primaryTintColor.colorWithAlphaComponent(0.1)
  }
  
  //MARK:- 初始化
  
  private func registerCellAndPrepareView() {
    let headNib   = UINib(nibName: "BCScheduleHeaderCell", bundle: nil)
    let leftNib   = UINib(nibName: "BCScheduleLeftCell", bundle: nil)
    let bodyNib   = UINib(nibName: "BCScheduleBodyCell", bundle: nil)
    
    collectionView.registerNib(headNib, forCellWithReuseIdentifier: "headCell")
    collectionView.registerNib(leftNib, forCellWithReuseIdentifier: "leftCell")
    collectionView.registerNib(bodyNib, forCellWithReuseIdentifier: "bodyCell")
    
    collectionView.backgroundColor = Color.primaryTintColor.colorWithAlphaComponent(0.1)
  }
}


private typealias collectionViewLayout = BCScheculeView
extension collectionViewLayout:UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width:CGFloat = (indexPath.row == 0) ? leftCellWidth :(ScreenWidth-leftCellWidth-1)/dayCount
    if indexPath.section == 0 {
      return CGSizeMake(width, leftCellWidth)
    } else if indexPath.section == 6 {
      if indexPath.row == 0 { return CGSizeMake(leftCellWidth,100)}
      else { return CGSizeMake(ScreenWidth - leftCellWidth - 2,100) }
      
    } else {
      return CGSizeMake(width, 100)
    }
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(1, 0, 0, 0)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
}

private typealias collectionViewDataSource = BCScheculeView
extension collectionViewDataSource:UICollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 7
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 6 {
      return 2
    }
    return Int(dayCount) + 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    if indexPath.section == 0 {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("headCell", forIndexPath: indexPath) as! BCScheduleHeaderCell
      cell.dayNameLabel.text = dayNamesListOriginal[indexPath.row]
      return cell
    } else if indexPath.row == 0 {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("leftCell", forIndexPath: indexPath) as! BCScheduleLeftCell
      cell.timeNameLabel.text = timeNamesList[indexPath.section]
      return cell
    } else {
      if indexPath.section == 6 {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("leftCell", forIndexPath: indexPath) as! BCScheduleLeftCell
        cell.timeNameLabel.text = DBManager.sharedManager().readUnScheduledClasses()
        return cell
      } else {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("bodyCell", forIndexPath: indexPath) as! BCScheduleBodyCell
        let models:[ScheduleModel]? = scheduleDictForShow["\(indexPath.section)-\(indexPath.row)"]
        cell.setupCellModels(models)
        return cell
      }
    }
  }
}

private typealias collectionViewDelegate = BCScheculeView
extension collectionViewDelegate:UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == 0 || indexPath.section == 0 { return }
    if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? BCScheduleBodyCell {
      let models:[ScheduleModel]? = cell.models
      delegate?.didSelecctedAtCell(indexPath,models:models)
    }
  }
}

