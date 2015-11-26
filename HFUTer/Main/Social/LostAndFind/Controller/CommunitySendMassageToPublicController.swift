//
//  CommunitySendMassageToPublicController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/26.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka
import Qiniu

class CommunitySendMassageToPublicController: EEBaseFormViewController {
  
  
  var isLost = false
  
  private var imagesList = [UIImage]()
  private var isSendedMassage = false
  
  private var uploadToken = ""
  private var uploadedFileName = [String]()
  private var isUploadingFile = [Bool]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initForm()
    if isLost {
      navTitle = "失误信息"
    } else {
      navTitle = "招领信息"
    }
    // Do any additional setup after loading the view.
  }
  
  private func checkValues() -> Bool{
    let values = form.values()
    if let massage = values["desc"] as? String {
      if massage.characters.count < 20 {
        Hud.showError("请填写20字符以上的描述")
        return false
      }
    } else {
      Hud.showError("请填写20字符以上的描述")
      return false
    }
    return true
  }
  
  private func sendMassage() {
    if self.checkValues() {
      let values = form.values()
      //准备图片列表
      for cell in ["image1","image2","image2"] {
        if let image = values[cell] as? UIImage {
          self.imagesList.append(image)
        }
      }
      Hud.showLoadingWithMask("正在上传")
      self.uploadedFileName = [String]()
      if imagesList.count > 0 {
        self.uploadFiles()
      } else {
        self.publishLostAndFoundMassage()
      }
    }
  }
  
  private func uploadFiles() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    BCGetQiNiuTokenRequest.get({ (result) -> () in
      if let token = result["data"] as? String {
        self.uploadToken = token
        for i in 0..<self.imagesList.count {
          self.isUploadingFile.append(false)
          self.uploadFilesToQiNiu(self.imagesList[i], completion: { Void in
            self.isUploadingFile[i] = true
            self.checkUpLoadIsGoing()
          })
        }
      }
      }, onFailedBlock: { (reason) -> () in
        Hud.showError(reason)
      }) { () -> () in
        Hud.showError("网络错误，请稍后再试")
    }
  }
  
  private func uploadFilesToQiNiu(image:UIImage,completion:(()->Void)?) {
    
    let resizedImage = RBResizeImage(image, targetSize: CGSize(width: 1000,height: 1000))
    let token = uploadToken
    let upManager = QNUploadManager()
    let filename = DataManager.getJpgFileName()
    let data = UIImageJPEGRepresentation(resizedImage, 0.9)
    upManager.putData(data, key: "lost/" + filename, token: token, complete: { (resposne, name, info) -> Void in
      if resposne.statusCode == 200 {
        self.uploadedFileName.append(filename)
      }
      completion?()
      }, option: nil)
  }
  
  private func checkUpLoadIsGoing() {
    if isUploadingFile.contains(false) {
      //Wait
    } else {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      self.publishLostAndFoundMassage()
    }
  }
  
  private func publishLostAndFoundMassage() {
    let values = form.values()
    let url = getComURL("api/lostFound/publishLostFound")
    
    var params = [String:AnyObject]()
    params["content"] = values["desc"] as? String
    if isLost {
      params["type"] = 0
    } else {
      params["type"] = 1
    }
    params["anonymous"] = values["anonymous"] as? Bool ?? false
    
    let json = try? NSJSONSerialization.dataWithJSONObject(uploadedFileName, options: NSJSONWritingOptions.init(rawValue: 0))
    if let json = json {
      let jsonString = NSString(data: json, encoding: NSUTF8StringEncoding)
      params["pic"] = jsonString
    }
    
    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
      onFinishedBlock: { (response) -> Void in
        Hud.showMassage("发布成功")
        self.isSendedMassage = true
        self.pop()
      }, onFailedBlock: { (reason) -> Void in
        Hud.showError(reason)
      }) { () -> Void in
        Hud.showError(NetErrorWarning)
    }
  }

  private func initForm() {
    self.tableView?.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)
    
    ImageRow.defaultCellSetup = { cell, row in
      cell.height = { 80 }
      
    }
    
    ImageRow.defaultCellUpdate = { cell, row in
      cell.accessoryView?.layer.cornerRadius = 5
      cell.accessoryView?.layer.borderWidth = 1
      cell.accessoryView?.layer.borderColor = UIColor.grayColor().CGColor
      cell.accessoryView?.frame = CGRectMake(0, 0, 80, 70)
      cell.accessoryView?.clipsToBounds = true
    }
    
    form
      +++ Section()
      <<< TextAreaRow("desc"){
        $0.placeholder = "请输入描述"
      }
      
      +++ Section("提示：如果上传图片，所需时间比较长，请耐心等待~")
      <<< ImageRow("image1"){
        $0.title = "选择图片"
      }
      <<< ImageRow("image2") {
        $0.title = "选择图片2"
        $0.hidden = "$image1  == nil"
      }
      
      <<< ImageRow("image3") {
        $0.title = "选择图片3"
        $0.hidden = "$image2  == nil"
      }
      
      <<< SwitchRow("anonymous"){
        $0.title = "匿名发布"
      }
      
      +++ Section()
      <<< ButtonRow("send"){
        $0.title = "发送"
        }
        .onCellSelection({ (cell, row) -> () in
          self.sendMassage()
        })
    
  }
}
