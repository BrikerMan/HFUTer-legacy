//
//  PersonDetailViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class PersonDetailViewController: EEBaseFormViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "个人信息"
    initFormView()
  }
  
  
  private func initFormView() {
    tableView?.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)
    
    ImageRow.defaultCellUpdate = { cell, row in
      cell.accessoryView?.layer.cornerRadius = 17
      cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
    }
    
    form +++
      Section()
      
      <<< ImageRow("image"){
        $0.title = "修改头像"
        $0.value = UIImage(named: "avatar")
      }
      
      +++ Section()
      <<< TextRow("name"){
        $0.title = "姓名"
        $0.disabled = true
        $0.value = DataEnv.eduUser.name
      }
      
      <<< TextRow("gender"){
        $0.title = "性别"
        $0.disabled = true
        $0.value = DataEnv.eduUser.gender
      }
      
      <<< TextRow("academy"){
        $0.title = "学院"
        $0.disabled = true
        $0.value = DataEnv.eduUser.academy
      }
      
      <<< TextRow("major"){
        $0.title = "专业"
        $0.disabled = true
        $0.value = DataEnv.eduUser.major
      }
      <<< TextRow("className"){
        $0.title = "班级"
        $0.disabled = true
        $0.value = DataEnv.eduUser.className
    }
    
  }
  
}
