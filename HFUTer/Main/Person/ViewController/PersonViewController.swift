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
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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


  private func initFormViews() {
    form +++
      Section()
      <<< ButtonRow("loginButton") {
        $0.title = "登录"
        $0.presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback {
          return BCLoginToEduViewController()
          }, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_login")
    }
      +++ Section("设置")

      <<< SwitchRow() {
        $0.title = "接受推送"
        $0.value = true
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_login")
      }

      <<< ButtonRow() { (row: ButtonRow) -> Void in
        row.title = "主题颜色选择"
        row.presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback {
          return BCLoginToEduViewController()
          }, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
        row.onCellSelection({ (cell, row) -> () in
          self.showColorChooseView()
        })
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_theme")
      }


      +++ Section("研究生专用，禁止自动加载课表和成绩")
      <<< SwitchRow() {
        $0.title = "禁止自动加载"
        $0.value = true
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_autoload")
      }

      +++ Section()

      <<< ButtonRow() {
        $0.title = "帮助"
        $0.presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback {
          return BCLoginToEduViewController()
          }, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_help")
      }

      <<< ButtonRow() {
        $0.title = "关于我们"
        $0.presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback {
          return BCLoginToEduViewController()
          }, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_about")
      }

      <<< ButtonRow() {
        $0.title = "隐私条款"
        $0.presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback {
          return BCLoginToEduViewController()
          }, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
        }.cellSetup { cell, row in
          cell.imageView?.image = UIImage(named: "person_legal")
    }
  }
}
