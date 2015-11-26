//
//  CommunityPublishLostMassageViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/26.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Qiniu

class CommunityPublishLostMassageViewController: EEBaseViewController {
  
  @IBOutlet weak var titleField: UITextView!
  @IBOutlet weak var imageView1: EEImageView!
  @IBOutlet weak var imageView2: EEImageView!
  @IBOutlet weak var imageView3: EEImageView!
  @IBOutlet weak var anonymousSwitch: UISwitch!
  
  var isLost = true
  
  var popBackBlock:(() -> Void)?
  
  private var imageIndex = 0
  private var imagesList = [UIImage]()
  private var imageViewList = [EEImageView]()
  private var isSendedMassage = false
  
  private var uploadToken = ""
  private var uploadedFileName = [String]()
  private var isUploadingFile = [Bool]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageViewList = [imageView1,imageView2,imageView3]
    addGasture()
    fixUI()
  }
  
  private func addGasture() {
    let tapGasture1 = UITapGestureRecognizer(target: self, action: "onTappedImageView1:")
    let tapGasture2 = UITapGestureRecognizer(target: self, action: "onTappedImageView2:")
    let tapGasture3 = UITapGestureRecognizer(target: self, action: "onTappedImageView3:")
    
    imageView1.addGestureRecognizer(tapGasture1)
    imageView2.addGestureRecognizer(tapGasture2)
    imageView3.addGestureRecognizer(tapGasture3)
    
    imageView1.userInteractionEnabled = true
    imageView2.userInteractionEnabled = true
    imageView3.userInteractionEnabled = true
  }
  
  private func fixUI() {
    //    self.showNavBarRightButton("nav_send")
    self.showNavRightButtonWithIcon("nav_send")
    //    self.anonymousSwitch.transform = CGAffineTransformMakeScale(0.75, 0.7)
  }
  
  override func pop() {
    if isSendedMassage {
      popBackBlock?()
    }
    super.pop()
  }
  
  override func onRightNavButtonPress() {
    if titleField.text.characters.count < 20 {
      Hud.showMassage("请输入20字以上的描述")
      return
    }
    
    Hud.showLoadingWithMask("正在上传")
    self.uploadedFileName = [String]()
    if imagesList.count > 0 {
      self.uploadFiles()
    } else {
      self.publishLostAndFoundMassage()
    }
  }
  
  func uploadFiles() {
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
  
  func uploadFilesToQiNiu(image:UIImage,completion:(()->Void)?) {
    
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
  
  func checkUpLoadIsGoing() {
    if isUploadingFile.contains(false) {
      //Wait
    } else {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      self.publishLostAndFoundMassage()
    }
  }
  
  
  func publishLostAndFoundMassage() {
    
    let url = getComURL("api/lostFound/publishLostFound")
    
    var params = [String:AnyObject]()
    params["content"] = titleField.text
    if isLost {
      params["type"] = 0
    } else {
      params["type"] = 1
    }
    params["anonymous"] = anonymousSwitch.on
    
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
  
  func onTappedImageView1(sender:AnyObject?) {
    imageIndex = 0
    showImageVCOrActionSheet()
  }
  
  func onTappedImageView2(sender:AnyObject?) {
    imageIndex = 1
    showImageVCOrActionSheet()
  }
  
  func onTappedImageView3(sender:AnyObject?) {
    imageIndex = 2
    showImageVCOrActionSheet()
  }
  
  private func showImageVCOrActionSheet() {
    self.view.endEditing(true)
    if imageIndex >= imagesList.count {
      showTakePhotoActionSheet()
    } else {
      let vc = EEBaseImagesListController(style: EEBaseImagesListControllerDataSource.Image)
      vc.images = imagesList
      vc.page = imageIndex
      vc.isEditMode = true
      vc.delegate = self
      self.pushToViewController(vc)
    }
  }
  
  private func showTakePhotoActionSheet() {
    let actionSheet = UIActionSheet()
    actionSheet.delegate = self
    actionSheet.title = "设置封面"
    actionSheet.addButtonWithTitle("取消")
    actionSheet.addButtonWithTitle("手机拍照")
    actionSheet.addButtonWithTitle("相册选择")
    actionSheet.cancelButtonIndex = 0
    actionSheet.showInView(self.view)
  }
  
  private func showImage(image:UIImage?) {
    
    if let image = image {
      let newImage = optimizeImage(image)
      imagesList.append(newImage)
    }
    
    for imageView in imageViewList {
      imageView.image = UIImage(named: "SendLostMassagePlaceHolder.png")
    }
    for i in 0..<imagesList.count {
      imageViewList[i].image = imagesList[i]
    }
  }
  
  private func optimizeImage(image:UIImage) -> UIImage {
    if image.size.height > 1000 || image.size.width > 1500 {
      let ratio = image.size.height/image.size.width
      let newSize = CGSizeMake(1000,1000 * ratio)
      UIGraphicsBeginImageContext(newSize)
      
      image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return newImage
    } else {
      return image
    }
  }
  
}


extension CommunityPublishLostMassageViewController:EEBaseImagesListControllerDelegate {
  func didDeletedImageAtIndex(index:Int) {
    imagesList.removeAtIndex(index)
    self.showImage(nil)
  }
}



extension CommunityPublishLostMassageViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    self.showImage(image)
    dismissViewControllerAnimated(true, completion: nil)
  }
}



extension CommunityPublishLostMassageViewController:UIActionSheetDelegate {
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == 1 {
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
        let piker = UIImagePickerController()
        piker.delegate = self
        piker.sourceType = .Camera
        self.presentViewController(piker, animated: true, completion: nil)
      }
      else {
        let alertView = UIAlertView(title: nil, message: "您的设备不支持拍照", delegate: nil, cancelButtonTitle: "知道了")
        alertView.show()
      }
    }
    else if buttonIndex == 2 {
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
        let piker = UIImagePickerController()
        piker.delegate = self
        piker.sourceType = .PhotoLibrary
        self.presentViewController(piker, animated: true, completion: nil)
      }
      else {
        let alertView = UIAlertView(title: nil, message: "您没有权限访问相册，请去设置->隐私进行设置!", delegate: nil, cancelButtonTitle: "知道了")
        alertView.show()
      }
    }
  }
}