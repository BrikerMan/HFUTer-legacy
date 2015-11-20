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

  override func viewDidLoad() {
    super.viewDidLoad()
initFormViews()
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  func initFormViews() {
    form +++
      Section()
      <<< ButtonRow("loginButton") {
        $0.title = "登录"
        $0.presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback {
          return BCLoginToEduViewController()
          }, completionCallback: { vc in vc.dismissViewControllerAnimated(true, completion: nil) })
    }
  }
}
