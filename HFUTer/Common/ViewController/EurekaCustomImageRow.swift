//
//  EurekaCustomImageRow.swift
//  Hande
//
//  Created by Eliyar Eziz on 15/11/18.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka
import Foundation

final class CustomImageRow : _CustomImageRow, RowType {
  required init(tag: String?) {
    super.init(tag: tag)
  }

}

class _CustomImageRow : SelectorRow<UIImage, CustomImagePickerController> {

  required init(tag: String?) {
    super.init(tag: tag)
    presentationMode = .PresentModally(controllerProvider: ControllerProvider.Callback {
      let vc = CustomImagePickerController()
      if tag == "avatar" {
        vc.cropSize = CGSize(width: 200, height: 200)
      } else {
        vc.cropSize = CGSize(width: 400, height: 600)
      }
      return vc
      }, completionCallback: { vc in vc.dismissViewControllerAnimated(false, completion: nil) })
    self.displayValueFor = nil
  }
  
  
  

  override func customUpdateCell() {
    super.customUpdateCell()
    cell.accessoryType = .None
    if let image = self.value {
      let imageView = UIImageView(frame: CGRectMake(0, 0, 50, 50))
      imageView.layer.cornerRadius = 50/2
      imageView.contentMode = .ScaleAspectFill
      imageView.image = image
      imageView.clipsToBounds = true
      cell.accessoryView = imageView
    }
    else{
      cell.accessoryView = nil
    }
  }
}


class CustomImagePickerController : UIImagePickerController, TypedRowControllerType, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EEImageCropViewControllerDelegate {

  var row: RowOf<UIImage>!
  var completionCallback : ((UIViewController) -> ())?

  private var cropSize:CGSize!

  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }

  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      let cropVC = EEImageCropViewController()
      cropVC.delegate = self
      cropVC.setImage(image, CropSize: cropSize, LimitScaleRatio: 3)
      self.presentViewController(cropVC, animated: false, completion: nil)
    }
  }

  func imagePickerControllerDidCancel(picker: UIImagePickerController){
    completionCallback?(self)
  }

  func imageCropperDidCancel(cropperViewController: EEImageCropViewController) {
    completionCallback?(self)
    self.dismissViewControllerAnimated(false, completion: nil)
  }

  func imageCropperViewController(cropperViewController: EEImageCropViewController, didFinished editedImage: UIImage) {
    completionCallback?(self)
    row.value = editedImage
    self.dismissViewControllerAnimated(false, completion: nil)
  }
}