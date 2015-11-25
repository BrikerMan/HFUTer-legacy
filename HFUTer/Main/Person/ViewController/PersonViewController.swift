//
//  PersonViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class PersonViewController: EEBaseFormViewController {
  
  private var colorChooseView:BCColorChooseView!
  private var colorChooseViewBack:UIView!
  
  private var isColorChooseViewShowing = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initFormViews()
    navTitle = "我的"
    NotifCenter.addObserver(self, selector: "afterLogin", name: BCUserLoginNotification, object: nil)
    if DataEnv.eduUser.isLogin {
      form.setValues(["isLogin":"edu"])
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc private func afterLogin() {
    form.setValues(["isLogin":"edu"])
    self.tableView?.reloadData()
  }
  
  override func onTintColorChanged() {
    super.onTintColorChanged()
    self.tableView?.reloadData()
  }
  
  private func showColorChooseView() {
    if !isColorChooseViewShowing {
      isColorChooseViewShowing = true
      
      colorChooseViewBack = UIView()
      colorChooseViewBack.backgroundColor = UIColor.blackColor()
      colorChooseViewBack.alpha = 0
      self.view.addSubview(colorChooseViewBack)
      
      let tapGasture = UITapGestureRecognizer(target: self, action: "hideColorChooseView")
      self.colorChooseViewBack.addGestureRecognizer(tapGasture)
      
      colorChooseViewBack.snp_makeConstraints(closure: { (make) -> Void in
        make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0))
      })
      
      colorChooseView = BCColorChooseView()
      colorChooseView.dismissBlock = {
        self.hideColorChooseView()
      }
      self.view.addSubview(colorChooseView)
      
      colorChooseView.snp_makeConstraints(closure: { (make) -> Void in
        make.width.equalTo(ScreenWidth-20)
        make.height.equalTo(280)
        make.center.equalTo(self.view.snp_center)
      })
      
      colorChooseView.transform = CGAffineTransformMakeScale(0.01, 0.01)
      self.view.layoutIfNeeded()
      
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.colorChooseView.transform = CGAffineTransformMakeScale(1, 1)
        self.colorChooseViewBack.alpha = 0.3
      })
    }
  }
  
  @objc private func hideColorChooseView() {
    if isColorChooseViewShowing {
      UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
        self.colorChooseView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        self.colorChooseViewBack.alpha = 0
        }, completion: { (finished) -> Void in
          self.isColorChooseViewShowing = false
          self.colorChooseView.removeFromSuperview()
          self.colorChooseViewBack.removeFromSuperview()
      })
    }
  }
  
  private func handeLogOut() {
    NotifCenter.postNotificationName(BCUserLogOutNotification, object: nil)
    DataEnv.handleLogOut()
    form.setValues(["isLogin":"notLogin"])
    self.tableView?.reloadData()
  }
  
  private func initFormViews() {
    
    
    form +++
      Section()
      
      //用于刷新列表 - 显示隐藏部分cell
      <<< SegmentedRow<String>("isLogin"){
        $0.options = ["notLogin", "edu", "com"]
        $0.value = "notLogin"
        $0.hidden = true
      }
      
      //登录Cell
      <<< ButtonRow("loginButton") {
        $0.title = "登录"
        $0.hidden = "$isLogin != 'notLogin'"
        
        $0.presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback {
          return BCLoginToEduViewController()
          }, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_login")
      }
      
      //用户详情Cell
      <<< PersonDetailTableRow("userDetail") {
        $0.hidden = "$isLogin == 'notLogin'"
      }
      +++ Section("设置")
      
      <<< SwitchRow() {
        $0.title = "接受推送 - 暂不可用"
        $0.value = true
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_login")
      }
      
      <<< ButtonRow() { (row: ButtonRow) -> Void in
        row.title = "主题颜色选择"
        row.onCellSelection({ (cell, row) -> () in
          self.showColorChooseView()
        })
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_theme")
          cell.textLabel?.textAlignment = .Left
          cell.textLabel?.textColor = nil
          cell.accessoryType = .DisclosureIndicator
      }
      
      
      +++ Section("研究生专用，禁止自动加载课表和成绩")
      <<< SwitchRow() {
        $0.title = "禁止自动加载 - 暂不可用"
        $0.value = true
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_autoload")
      }
      
      +++ Section()
      
      <<< ButtonRow() {
        $0.title = "帮助 - 暂不可用"
        $0.presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback {
          return BCLoginToEduViewController()
          }, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_help")
      }
      
      <<< ButtonRow() {
        $0.title = "关于我们 - 暂不可用"
        $0.presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback {
          return BCLoginToEduViewController()
          }, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_about")
      }
      
      <<< ButtonRow() {
        $0.title = "隐私条款 - 暂不可用"
        $0.presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback {
          return BCLoginToEduViewController()
          }, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_legal")
      }
      
      +++ Section() {
        if !DataEnv.eduUser.isLogin { $0.hidden = true }
      }
      
      <<< ButtonRow() {
        $0.title = "退出"
        $0.hidden = "$isLogin == 'notLogin'"
        } .onCellSelection({ (cell, row) -> () in
          self.handeLogOut()
        })
  }
}
