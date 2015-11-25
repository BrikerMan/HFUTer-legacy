//
//  BCScheduleEditViewController.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

//import UIKit
import Eureka
import SnapKit


class BCScheduleEditViewController:EEBaseFormViewController {

  var model:ScheduleModel?
  var dismissBlock:(()->())?

  private var scheduleWeeks = [Int]()
  private var memo = ScheduleMemoModel()

  private var weekChooseViewBackView:UIView?
  private var weekChooseView:BCShcedulesWeekEditView?

  private var isWeekChooseViewShowing = false
  //MARK:- 生命周期
  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = UIColor.whiteColor()
    if let model = model {
      navTitle = "编辑课程"
      self.scheduleWeeks = model.weeks
      memo = ScheduleMemoModel.readMemo(model.id)
    } else {
      navTitle = "添加课程"
    }
    self.showNavRightButtonWithIcon("navbar_save")
    initialForm()
  }


  //MARK:- 动作
  func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
    showChooseWeekView()
  }

  func saveSchedule() {
    let values = form.values()
    if let model = model {
      model.weeks = self.scheduleWeeks
      model.name  = values["name"] as? String ?? ""
      model.place = values["place"] as? String ?? ""
      model.hour  = ScheduleModel.timeStringToInt(values["hour"] as? String ?? "")
      model.day   = ScheduleModel.stringToDay(values["day"] as? String ?? "")
      ScheduleModel.updateSchedule(model)
    } else {
      let model = ScheduleModel()
      model.weeks = self.scheduleWeeks
      model.name  = values["name"] as? String ?? ""
      model.place = values["place"] as? String ?? ""
      model.hour  = ScheduleModel.timeStringToInt(values["hour"] as? String ?? "")
      model.day   = ScheduleModel.stringToDay(values["day"] as? String ?? "")
      ScheduleModel.saveSchedule(model)
    }
  }

  func saveMemo() {
    if let model = model {
      let values = form.values()
      let memo = ScheduleMemoModel()
      memo.schedule_id = model.id
      memo.teacherName = values["teacher"] as? String ?? ""
      memo.memoContent = values["memoContent"] as? String ?? ""
      memo.memoTitle = values["memoTitle"] as? String ?? ""
      ScheduleMemoModel.saveMemo(memo)
    }
  }

  override func onRightNavButtonPress() {
    if scheduleWeeks.count == 0 {
      Hud.showMassage("请选择课程周")
      return
    }
    saveSchedule()
    saveMemo()
    self.dismissBlock?()
    self.pop()
  }

  //MARK:- 动画
  func showChooseWeekView() {
    if !isWeekChooseViewShowing {
      weekChooseViewBackView = UIView()
      weekChooseViewBackView?.backgroundColor = UIColor.blackColor()
      weekChooseViewBackView?.alpha = 0
      self.view.addSubview(weekChooseViewBackView!)

      let tapGasture = UITapGestureRecognizer(target: self, action: "hideChooseWeekView")
      self.weekChooseViewBackView?.addGestureRecognizer(tapGasture)

      weekChooseViewBackView?.snp_makeConstraints(closure: { (make) -> Void in
        make.edges.equalTo(self.view)
      })

      weekChooseView = BCShcedulesWeekEditView()
      weekChooseView?.weekList = model?.weeks ?? [Int]()
      weekChooseView?.dissmissBlock = { (weeklist) in
        self.scheduleWeeks = weeklist
        self.hideChooseWeekView()
      }
      self.view.addSubview(weekChooseView!)

      weekChooseView?.snp_makeConstraints(closure: { (make) -> Void in
        make.left.equalTo(self.view.snp_left)
        make.right.equalTo(self.view.snp_right)
        make.height.equalTo(210)
        make.top.equalTo(self.view.snp_bottom)
      })

      self.view.layoutIfNeeded()

      UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn,
        animations: { () -> Void in
          self.weekChooseViewBackView?.alpha = 0.3

          self.weekChooseView?.snp_updateConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.view.snp_bottom).offset(-210)
          })
          self.view.layoutIfNeeded()
        }, completion: nil)

      isWeekChooseViewShowing = true
    }
  }

  func hideChooseWeekView() {
    if isWeekChooseViewShowing {
      UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn,
        animations: { () -> Void in
          self.weekChooseViewBackView?.alpha = 0
          self.weekChooseView?.snp_updateConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.view.snp_bottom)
          })
          self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
          self.weekChooseViewBackView?.removeFromSuperview()
          self.weekChooseView?.removeFromSuperview()
          self.isWeekChooseViewShowing = false
      })
    }
  }

  //MARK:- 初始化
  func initialForm() {
    self.tableView?.frame = CGRectMake(0, 40, ScreenWidth, ScreenHeight-40)

    NameRow.defaultCellSetup = { cell, row in
      cell.textLabel?.textColor = Color.primaryDarkColor
    }

    form +++ Section("基础信息") {
      $0.header = nil
      }
      <<< TextRow("name") {
        $0.title = "名称"
        $0.placeholder = "课程名字"
        $0.value = self.model?.name
      }

      <<< TextRow("place") {
        $0.title = "教室"
        $0.placeholder = "教室名字"
        $0.value = self.model?.place
      }

      <<< TextRow("teacher") {
        $0.title = "老师"
        $0.placeholder = "(未填写)"
        $0.value =  {
          if self.memo.teacherName != "" {
            return self.memo.teacherName
          }
          return nil
          }()
      }
      <<< ActionSheetRow<String>("day") {
        $0.title = "星期"
        $0.selectorTitle = "选择日子"
        $0.options = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]
        $0.value = ScheduleModel.dayToString(self.model?.day)
      }

      <<< ActionSheetRow<String>("hour") {
        $0.title = "课时"
        $0.selectorTitle = "选择课时"
        $0.options = ["1-2节", "3-4节", "5-6节", "7-8节", "9-11节"]
        $0.value = ScheduleModel.classTimeToString(self.model?.hour)
      }
      <<< ButtonRow("weeks") {
        $0.title = "选择课程周"
        $0.onCellSelection(self.buttonTapped)
    }

    if model != nil {
      form +++ Section("")
        <<< TextRow("memoTitle") {
          $0.placeholder = "标题"
          $0.value =  {
            if self.memo.memoTitle != "" {
              return self.memo.memoTitle
            }
            return nil
            }()
        }

        <<< TextAreaRow("memoContent") {
          $0.placeholder = "备注"
          $0.value =  {
            if self.memo.memoContent != "" {
              return self.memo.memoContent
            }
            return nil
            }()
      }
    }
  }
}
