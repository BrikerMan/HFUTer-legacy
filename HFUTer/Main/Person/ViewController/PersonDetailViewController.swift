//
//  PersonDetailViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka
import Qiniu

class PersonDetailViewController: EEBaseFormViewController {
  
  private var newAvatar:UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "个人信息"
    initFormView()
    
  }
  
  @objc private func onUpdateButtonPressed() {
    self.updateUserAvatarImage()
  }
  
  private func updateUserAvatarImage() {
    if let image = self.form.values()["avatar"] as? UIImage  {
      Hud.showLoading("正在更新")
      BCGetQiNiuTokenRequest.get { (token, error) -> () in
        if let token = token {
          let resizedImage = RBResizeImage(image, targetSize: CGSize(width: 1000,height: 1000))
          let upManager = QNUploadManager()
          let filename = DataManager.getJpgFileName()
          let data = UIImageJPEGRepresentation(resizedImage, 0.9)
          upManager.putData(data, key: "icon/" + filename, token: token, complete: {
            (resposne, name, info) -> Void in
            if resposne.statusCode == 200 {
              self.newAvatar = resizedImage
              self.updateUserInfoWithAvatarName(filename)
            }
            }, option: nil)
        } else {
          Hud.showError(error)
        }
      }
    }
  }
  
  private func updateUserInfoWithAvatarName(filename:String) {
    let url = getComURL("api/user/updateUserInfo")
    let params = [
      "image":filename
    ]
    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
      onFinishedBlock: { (response) -> Void in
        Hud.showMassage("更新成功")
        if let newAvatar = self.newAvatar {
          DataEnv.comUser.avatarImage = newAvatar
        }
      }, onFailedBlock: { (reason) -> Void in
        Hud.showError(reason)
      }) { () -> Void in
        Hud.showError(NetErrorWarning)
    }
  }
  
  private func initFormView() {
    tableView?.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)
    
//    CustomImageRow.defaultCellSetup = { cell, row in
//      cell.height = { 60 }
//    }
    
    form +++
      Section()
      
//      <<< CustomImageRow("avatar"){
//        $0.title = "修改头像"
//        $0.value = DataEnv.comUser.avatarImage
//      }
      
      <<< TextRow("email"){
        $0.title = "邮箱"
        $0.value = "暂不提供"
        $0.disabled = true
      }
      
      <<< ButtonRow("submit"){
        $0.title = "保存"
        $0.onCellSelection({ (cell, row) -> () in
          self.onUpdateButtonPressed()
        })
      }
      
      +++ Section("教务系统信息")
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
