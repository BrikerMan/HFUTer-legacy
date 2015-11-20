//
//  HomeViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HomeViewController: EEBaseViewController {

  @IBOutlet weak var scrollView: UIScrollView!

  //主Views
  private var homeNavbar:HomeNavBarView!
  private var gradesView:BCGradesTableView!
  private var scheduleView:BCScheculeView!

  private var selectWeekView:BCScheduleSelectView!
  private var selectWeekViewBackView:UIView!

  //数据
  private var scheduleList          = [ScheduleModel]()
  private var gradesBySemester      = [[GradeModel]]()
  private var currentSelectedModels = [ScheduleModel]()

  //状态
  private var isGetScheduleListRequestGoing = false
  private var isGetGradesRequestGoing       = false
  private var isSelectWeekViewShowing       = false

  override func viewDidLoad() {
    super.viewDidLoad()
    initUI()
    NotifCenter.addObserver(self, selector: "afterLogin:", name: BCUserLoginNotification, object: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
      self.scheduleView.showCurrentWeeksSchedule(nil)
      if self.gradesBySemester.count == 1 && self.gradesBySemester[0].count == 0 {
        self.beginGetGradesRequest()
      } else {
        self.gradesView.reloadGrades()
      }
    }
  }

  func initUI() {
    homeNavbar = HomeNavBarView()
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
}

extension HomeViewController:BCScheculeViewDelegate {
  func didSelecctedAtCell(indexPath: NSIndexPath,models:[ScheduleModel]?) {
    if let models = models {
      if models.count > 1 {
        self.currentSelectedModels = models
        let actionSheet = UIActionSheet()
        for model in models {
          actionSheet.addButtonWithTitle(model.name)
        }
        actionSheet.showInView(self.view)
      } else {
        let vc = BCScheduleEditViewController()
        vc.model = models[0]
//        vc.isNavRightButtonChangeToBack = true
        vc.dismissBlock = {
          self.scheduleView.showCurrentWeeksSchedule(nil)
        }
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }
  }
}


extension HomeViewController:BCScheduleSelectViewDelegate {
  func didSelectedOnWeek(week:Int) {
//    self.hideSelectWeekView(nil)
    scheduleView.showCurrentWeeksSchedule(week)
//    navTitleLabel.text = "第\(week)周"
  }
}

extension HomeViewController:UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let page = Int((scrollView.contentOffset.x)/ScreenWidth)
    homeNavbar.setSwitchToIndex(page)
  }
}

extension HomeViewController:HomeNavBarViewDelegate {
  func homeNavBar(NavBar homeNavBar:HomeNavBarView,didSelecectedAtIndex index:Int) {
      self.scrollView.scrollRectToVisible(CGRectMake(ScreenWidth*CGFloat(index),0,scrollView.frame.width,scrollView.frame.height), animated: true)
  }

  func homeNavBar(NavBar homeNavBar:HomeNavBarView,didPressObSelcetWeekView isOpen:Bool) {

  }
}
