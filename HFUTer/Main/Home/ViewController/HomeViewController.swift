//
//  HomeViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HomeViewController: EEBaseViewController {
  
  
  //主Views
  private var scrollView = UIScrollView()
  private var homeNavbar = HomeNavBarView()
  private var gradesView:BCGradesTableView!
  private var scheduleView:BCScheculeView!
  
  private var selectWeekView:BCScheduleSelectView!
  private var selectWeekViewBackView:UIView!
  private var eduUserNotLoginView:BCEduUserNotLoginView?
  
  //数据
  private var scheduleList          = [ScheduleModel]()
  private var gradesBySemester      = [[GradeModel]]()
  private var currentSelectedModels = [ScheduleModel]()
  
  //状态
  private var isGetScheduleListRequestGoing = false
  private var isGetGradesRequestGoing       = false
  private var isSelectWeekViewShowing       = false
  private var isNotLoginViewShwoing         = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initUI()
    if DataEnv.eduUser.isLogin {
      afterLogin(nil)
    } else {
      addEduUserNotLoginView()
    }
    fixUI()
    NotifCenter.addObserver(self, selector: "afterLogin:", name: BCUserLoginNotification, object: nil)
    NotifCenter.addObserver(self, selector: "afterLogOut:", name: BCUserLogOutNotification, object: nil)
  }
  
  
  //MARK:- 网络请求
  private func beginGetScheduleList(runAfterBlock:(() -> Void)?) {
    if !isGetScheduleListRequestGoing {
      isGetScheduleListRequestGoing = true
      Hud.showLoadingWithMask("正在获取课表")
      let operation = BCGetSceduleRequest()
      operation.getRequest(onFinishedBlock: { () -> Void in
        self.scheduleList = ScheduleModel.readScheduleModelForWeek(nil)
        Hud.dismiss()
        self.scheduleView.showCurrentWeeksSchedule(nil)
        self.isGetScheduleListRequestGoing = false
        runAfterBlock?()
        }, onFailedBlock: { (error) -> Void in
          Hud.showError(error)
          self.isGetScheduleListRequestGoing = false
      })
    }
  }
  
  private func beginGetGradesRequest() {
    if !isGetGradesRequestGoing {
      isGetScheduleListRequestGoing = true
      Hud.showLoadingWithMask("正在获取成绩")
      let operation = BCGetGradesRequest()
      operation.getRequest(
        { () -> Void in
          self.gradesBySemester = GradeModel.getGradesBySemester()
          self.gradesView.reloadGrades()
          Hud.dismiss()
          self.isGetScheduleListRequestGoing = false
        }, onFailedBlock: { (error) -> Void in
          Hud.showError(error)
          self.isGetScheduleListRequestGoing = false
      })
      
    }
  }
  
  //MARK:- 动画
  @objc private func showSelectWeekView(sender:AnyObject?) {
    if !isSelectWeekViewShowing {
      isSelectWeekViewShowing = true
      
      selectWeekViewBackView = UIView()
      selectWeekViewBackView.backgroundColor = UIColor.blackColor()
      selectWeekViewBackView.alpha = 0
      self.view.addSubview(selectWeekViewBackView)
      
      let tapGasuture = UITapGestureRecognizer(target: self, action: "hideSelectWeekView:")
      self.selectWeekViewBackView.addGestureRecognizer(tapGasuture)
      
      selectWeekViewBackView.snp_makeConstraints(closure: { (make) -> Void in
        make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0))
      })
      
      selectWeekView = BCScheduleSelectView()
      selectWeekView.delegate = self
      self.view.addSubview(selectWeekView)
      self.view.bringSubviewToFront(homeNavbar)
      
      selectWeekView.alpha = 0
      selectWeekView.snp_makeConstraints(closure: { (make) -> Void in
        make.height.equalTo(258)
        make.width.equalTo(100)
        make.right.equalTo(self.view.snp_right).offset(-5)
        make.bottom.equalTo(self.homeNavbar.snp_bottom)
      })
      
      self.view.layoutIfNeeded()
      
      UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
        self.selectWeekView.alpha = 1
        self.selectWeekViewBackView.alpha = 0.3
        self.homeNavbar.slideDownImage.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        
        self.selectWeekView.snp_updateConstraints(closure: { (make) -> Void in
          make.bottom.equalTo(self.homeNavbar.snp_bottom).offset(258)
        })
        self.view.layoutIfNeeded()
        }, completion: nil)
      
    }
  }
  
  @objc private func hideSelectWeekView(sender:AnyObject?) {
    if isSelectWeekViewShowing {
      UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
        self.selectWeekView.alpha = 0
        self.selectWeekViewBackView.alpha = 0
        self.homeNavbar.slideDownImage.transform = CGAffineTransformMakeRotation(CGFloat(0))
        self.selectWeekView.snp_updateConstraints(closure: { (make) -> Void in
          make.bottom.equalTo(self.homeNavbar.snp_bottom)
        })
        self.view.layoutIfNeeded()
        }, completion: {(finished) in
          self.selectWeekView.removeFromSuperview()
          self.selectWeekViewBackView.removeFromSuperview()
          self.isSelectWeekViewShowing = false
      })
    }
  }
  
  //MARK:- 处理用户状态变化
  @objc private func afterLogin(notification:NSNotification?) {
    self.scheduleList = ScheduleModel.readScheduleModelForWeek(nil)
    self.gradesBySemester  = GradeModel.getGradesBySemester()
    if self.scheduleList.count == 0 {
      self.beginGetScheduleList({ () -> Void in
        if self.gradesBySemester.count == 1 && self.gradesBySemester[0].count == 0 {
          self.beginGetGradesRequest()
        } else {
          self.gradesView.reloadGrades()
        }
      })
    } else {
      self.scheduleView.showCurrentWeeksSchedule(DataEnv.currentWeek)
      if self.gradesBySemester.count == 1 && self.gradesBySemester[0].count == 0 {
        self.beginGetGradesRequest()
      } else {
        self.gradesView.reloadGrades()
      }
    }
    homeNavbar.initUserLogin(true)
    hideEduUserNotLoginView()
  }
  
  @objc private func afterLogOut(notification:NSNotification?) {
    self.addEduUserNotLoginView()
  }
  
  private func addEduUserNotLoginView() {
    if !isNotLoginViewShwoing {
      isNotLoginViewShwoing = true
      let noLoginView = BCEduUserNotLoginView()
      self.view.addSubview(noLoginView)
      
      noLoginView.snp_makeConstraints(closure: { (make) -> Void in
        make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0))
      })
      
      homeNavbar.initUserLogin(false)
      eduUserNotLoginView = noLoginView
    }
  }
  
  private func hideEduUserNotLoginView() {
    homeNavbar.initUserLogin(true)
    if isNotLoginViewShwoing {
      eduUserNotLoginView?.removeFromSuperview()
      isNotLoginViewShwoing = false
    }
  }
  
  override func onTintColorChanged() {
    self.homeNavbar.view?.backgroundColor = Color.primaryTintColor
    homeNavbar.runkeeperSwitch.selectedTitleColor = Color.primaryTintColor
    gradesView.changeTintColor()
    scheduleView.changeTintColor()
  }
  
  private func initUI() {
    homeNavbar.delegate = self
    self.view.addSubview(homeNavbar)
    
    homeNavbar.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(self.view.snp_top)
      make.left.equalTo(self.view.snp_left)
      make.right.equalTo(self.view.snp_right)
      make.height.equalTo(64)
    }
    
    
    self.scrollView.pagingEnabled = true
    self.scrollView.showsHorizontalScrollIndicator = false
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 2, scrollView.frame.size.height);
    self.scrollView.delegate = self
    
    self.view.addSubview(scrollView)
    
    scrollView.snp_makeConstraints { (make) -> Void in
      make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 49, 0))
    }
    
    
    scheduleView = BCScheculeView()
    scheduleView.delegate = self
    self.scrollView.addSubview(scheduleView)
    
    scheduleView.snp_makeConstraints(closure: { (make) -> Void in
      make.top.equalTo(self.scrollView.snp_top)
      make.left.equalTo(self.scrollView.snp_left)
      make.width.equalTo(self.scrollView.snp_width)
      make.height.equalTo(self.scrollView.snp_height)
    })
    
    gradesView = BCGradesTableView()
    self.scrollView.addSubview(gradesView)
    
    gradesView.snp_makeConstraints(closure: { (make) -> Void in
      make.top.equalTo(self.scrollView.snp_top)
      make.left.equalTo(self.scrollView.snp_left).offset(ScreenWidth)
      make.width.equalTo(self.scrollView.snp_width)
      make.height.equalTo(self.scrollView.snp_height)
    })
  }
  
  private func fixUI() {
    homeNavbar.titleLabel.text = "第\(DataEnv.currentWeek)周"
    homeNavbar.runkeeperSwitch.selectedTitleColor = Color.primaryTintColor
    self.homeNavbar.view?.backgroundColor = Color.primaryTintColor
  }
}

//MARK:- ActionViewDelegate
extension HomeViewController:UIActionSheetDelegate {
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    let vc = BCScheduleEditViewController()
    vc.model = currentSelectedModels[buttonIndex]
    vc.dismissBlock = {
      self.scheduleView.showCurrentWeeksSchedule(nil)
    }
    self.pushToViewController(vc)
  }
}



//MARK:- BCScheculeViewDelegate
extension HomeViewController:BCScheculeViewDelegate {
  func didSelecctedAtCell(indexPath: NSIndexPath,models:[ScheduleModel]?) {
    if let models = models {
      if models.count > 1 {
        //如果多个课程则显示选择按钮
        self.currentSelectedModels = models
        let actionSheet = UIActionSheet()
        actionSheet.delegate = self
        for model in models {
          actionSheet.addButtonWithTitle(model.name)
        }
        actionSheet.showInView(self.view)
      } else {
        //编辑现有课程
        let vc = BCScheduleEditViewController()
        vc.model = models[0]
        vc.dismissBlock = {
          self.scheduleView.showCurrentWeeksSchedule(nil)
        }
        self.pushToViewController(vc)
      }
    } else {
      //创建新课程
      let vc = BCScheduleEditViewController()
      vc.dismissBlock = {
        self.scheduleView.showCurrentWeeksSchedule(nil)
      }
      self.pushToViewController(vc)
    }
  }
}

//MARK:- BCScheduleSelectViewDelegate
extension HomeViewController:BCScheduleSelectViewDelegate {
  func didSelectedOnWeek(week:Int) {
    self.hideSelectWeekView(nil)
    scheduleView.showCurrentWeeksSchedule(week)
    homeNavbar.titleLabel.text = "第\(week)周"
  }
}

//MARK:- UIScrollViewDelegate
extension HomeViewController:UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let page = Int((scrollView.contentOffset.x+ScreenWidth/2)/ScreenWidth)
    homeNavbar.setSwitchToIndex(page)
  }
}

//MARK:- HomeNavBarViewDelegate
extension HomeViewController:HomeNavBarViewDelegate {
  func homeNavBar(NavBar homeNavBar:HomeNavBarView,didSelecectedAtIndex index:Int) {
    self.scrollView.scrollRectToVisible(CGRectMake(ScreenWidth*CGFloat(index),0,scrollView.frame.width,scrollView.frame.height), animated: true)
  }
  
  func homeNavBarDidPressObSelcetWeekView(NavBar: HomeNavBarView) {
    if DataEnv.eduUser.isLogin {
      if isSelectWeekViewShowing {
        self.hideSelectWeekView(nil)
      } else {
        self.showSelectWeekView(nil)
      }
    }
  }
}
