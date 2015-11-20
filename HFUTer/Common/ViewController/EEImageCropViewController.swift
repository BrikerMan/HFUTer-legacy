//
//  EEImageCropViewController.swift
//  Hande
//
//  Created by Eliyar Eziz on 15/11/18.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol EEImageCropViewControllerDelegate {
  func imageCropperViewController(cropperViewController:EEImageCropViewController, didFinished editedImage:UIImage)
  func imageCropperDidCancel(cropperViewController:EEImageCropViewController)
}

class EEImageCropViewController: UIViewController {

  var delegate:EEImageCropViewControllerDelegate?

  private var showImgView:UIImageView!
  private var overlayView:UIView!
  private var ratioView  :UIView!
  private var controlView:UIView!

  private var cropSize:CGSize!
  private var cropFrame:CGRect!

  private var oldFrame:CGRect!
  private var largeFrame:CGRect!
  private var latestFrame:CGRect!
  private var limitRatio:CGFloat!

  private var originalImage:UIImage!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  func setImage(originalImage:UIImage, CropSize cropSize:CGSize, LimitScaleRatio limitRatio:CGFloat) {
    self.cropSize = cropSize
    self.limitRatio = limitRatio
    self.originalImage = self.imageByScalingAndCroppingForSourceImage(originalImage, targetSize: originalImage.size)
    self.initView()
  }

  private func initView() {
    self.view.backgroundColor = UIColor.blackColor()

    showImgView = UIImageView(frame: self.view.frame)
    showImgView.backgroundColor = UIColor.blackColor()
    showImgView.userInteractionEnabled = true
    showImgView.clipsToBounds = true
    showImgView.multipleTouchEnabled = true
    showImgView.image = self.originalImage
    view.addSubview(showImgView)

    overlayView = UIView(frame:self.view.frame)
    overlayView.backgroundColor = UIColor.blackColor()
    overlayView.alpha = 0.45
    view.addSubview(overlayView)

    ratioView = UIView(frame: CGRectMake(0,0,ScreenWidth,ScreenWidth * (cropSize.height/cropSize.width)))
    ratioView.userInteractionEnabled = true
    view.addSubview(ratioView)

    ratioView.center.y          = ScreenHeight/2

    let imageWidth = originalImage.size.width
    let imageHeight = originalImage.size.height

    let selfWidth = ScreenWidth
    let selfHeight = ScreenHeight

    if imageWidth/imageHeight == selfWidth/selfHeight {
      self.showImgView.frame = self.view.frame
    } else if imageWidth/imageHeight > selfWidth/selfHeight {
      self.showImgView.frame = CGRectMake(0, selfHeight/2-selfWidth*imageHeight/imageWidth/2, selfWidth, selfWidth*imageHeight/imageWidth)
    } else {
      self.showImgView.frame = CGRectMake(selfWidth/2-selfHeight*imageWidth/imageHeight/2, 0, selfHeight*imageWidth/imageHeight, selfHeight)
    }

    self.oldFrame = showImgView.frame
    self.latestFrame = self.oldFrame
    self.largeFrame = CGRectMake(0, 0, self.limitRatio * self.oldFrame.size.width, self.limitRatio * self.oldFrame.size.height)

    self.addGestureRecognizers()

    self.cropFrame = CGRectMake(0, selfHeight/2-cropSize.height/2, cropSize.width, cropSize.height);
    self.ratioView.layer.borderColor = UIColor.whiteColor().CGColor
    self.ratioView.layer.borderWidth = 1.0
    self.ratioView.autoresizingMask = .None

    overlayClipping()
    addButtons()
  }


  private func overlayClipping() {
    let maskLayer =  CAShapeLayer()
    let path = CGPathCreateMutable()

    // Left side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
      self.ratioView.frame.origin.x,
      self.overlayView.frame.size.height))

    // Right side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(
      self.ratioView.frame.origin.x + self.ratioView.frame.size.width,
      0,
      self.overlayView.frame.size.width - self.ratioView.frame.origin.x - self.ratioView.frame.size.width,
      self.overlayView.frame.size.height))

    // Top side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
      self.overlayView.frame.size.width,
      self.ratioView.frame.origin.y))

    // Bottom side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
      self.ratioView.frame.origin.y + self.ratioView.frame.size.height,
      self.overlayView.frame.size.width,
      self.overlayView.frame.size.height - self.ratioView.frame.origin.y + self.ratioView.frame.size.height))

    maskLayer.path = path
    self.overlayView.layer.mask = maskLayer
  }

  private func addGestureRecognizers() {
    let pinchGasture = UIPinchGestureRecognizer(target: self, action: "pinchView:")
    self.view.addGestureRecognizer(pinchGasture)

    let panGasture   = UIPanGestureRecognizer(target: self, action: "panView:")
    self.view.addGestureRecognizer(panGasture)
  }

  private func addButtons() {
    let conformButton  = UIButton(frame: CGRectMake(ScreenWidth-70,ScreenHeight-40,60,30))
    conformButton.addTarget(self, action: "onConformButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    conformButton.setTitle("确认", forState: .Normal)
    conformButton.titleLabel?.textColor = UIColor.whiteColor()
    self.view.addSubview(conformButton)


    let cancelButton  = UIButton(frame: CGRectMake(10,ScreenHeight-40,60,30))
    cancelButton.addTarget(self, action: "onCancelButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    cancelButton.setTitle("取消", forState: .Normal)
    cancelButton.titleLabel?.textColor = UIColor.whiteColor()
    self.view.addSubview(cancelButton)
  }

  @objc private func pinchView(pinchGestureRecognizer:UIPinchGestureRecognizer) {
    let view = self.showImgView
    if pinchGestureRecognizer.state == .Began || pinchGestureRecognizer.state == .Changed {
      view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale)
      pinchGestureRecognizer.scale = 1
    } else if pinchGestureRecognizer.state == .Ended {
      var newFrame = self.showImgView.frame
      newFrame = self.handleScaleOverflow(newFrame)
      newFrame = self.handleBorderOverflow(newFrame)

      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.showImgView.frame = newFrame
        self.latestFrame = newFrame
      })
    }
  }


  @objc private func panView(panGestureRecognizer:UIPanGestureRecognizer) {
    let view = self.showImgView
    if panGestureRecognizer.state == .Began || panGestureRecognizer.state == .Changed {
      // calculate accelerator
      let absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
      let absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
      let scaleRatio = self.showImgView.frame.size.width / self.cropFrame.size.width;
      let acceleratorX = 1 - abs(absCenterX - view.center.x) / (scaleRatio * absCenterX);
      let acceleratorY = 1 - abs(absCenterY - view.center.y) / (scaleRatio * absCenterY);
      let translation = panGestureRecognizer.translationInView(view.superview)
      view.center = CGPoint(x: view.center.x + translation.x * acceleratorX, y: view.center.y + translation.y * acceleratorY)
      panGestureRecognizer.setTranslation(CGPointZero, inView: view.superview)
    } else if panGestureRecognizer.state == .Ended {
      var newFrame = self.showImgView.frame
      newFrame = self.handleBorderOverflow(newFrame)
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.showImgView.frame = newFrame
        self.latestFrame = newFrame
      })
    }
  }

  private func handleScaleOverflow(var newFrame:CGRect) -> CGRect {
    // bounce to original frame
    let oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < self.cropFrame.size.width) {
      newFrame = self.oldFrame;
    }
    if (newFrame.size.width > self.largeFrame.size.width) {
      newFrame = self.largeFrame;   //图片最大时起始点是(0,0)
    }
    if (newFrame.size.height < self.cropFrame.size.height) {
      newFrame = self.oldFrame;
    }
    if (newFrame.size.height > self.largeFrame.size.height) {
      newFrame = self.largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
  }


  private func handleBorderOverflow(var newFrame:CGRect) -> CGRect {
    // horizontally
    if (newFrame.origin.x > self.cropFrame.origin.x)  {
      newFrame.origin.x = self.cropFrame.origin.x
    }
    if (CGRectGetMaxX(newFrame) < self.cropFrame.size.width) {
      //      newFrame.origin.x = self.cropFrame.size.width - newFrame.size.width;
    }

    // vertically
    if (newFrame.origin.y > self.cropFrame.origin.y) {
      newFrame.origin.y = self.cropFrame.origin.y
    }
    if (CGRectGetMaxY(newFrame) < self.cropFrame.origin.y + self.cropFrame.size.height) {
      newFrame.origin.y = self.cropFrame.origin.y + self.cropFrame.size.height - newFrame.size.height;
    }

    // adapt horizontally rectangle
    if (self.showImgView.frame.size.width > self.showImgView.frame.size.height && newFrame.size.height <= self.cropFrame.size.height) {
      newFrame.origin.y = self.cropFrame.origin.y + (self.cropFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
  }

  private func imageByScalingAndCroppingForSourceImage(sourceImage:UIImage, targetSize:CGSize) -> UIImage {
    var newImage:UIImage?
    let imageSize = sourceImage.size;
    let width = imageSize.width;
    let height = imageSize.height;
    let targetWidth = targetSize.width;     //640
    let targetHeight = targetSize.height;   //350

    var scaleFactor:CGFloat = 0.0;
    var scaledWidth:CGFloat = targetWidth;
    var scaledHeight:CGFloat = targetHeight;

    var thumbnailPoint = CGPointMake(0.0,0.0);

    if !CGSizeEqualToSize(imageSize, targetSize) {
      let widthFactor = targetWidth / width;
      let heightFactor = targetHeight / height;
      if (widthFactor > heightFactor) {
        scaleFactor = widthFactor; // scale to fit height
      } else {
        scaleFactor = heightFactor; // scale to fit width
      }

      scaledWidth  = CGFloat(width * widthFactor)
      scaledHeight = CGFloat(height * heightFactor)

      // center the image
      if (widthFactor > heightFactor)
      {
        thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
      }
      else if (widthFactor < heightFactor)
      {
        thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
      }
    }

    UIGraphicsBeginImageContext(targetSize); // this will crop

    var thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;

    thumbnailRect.size.width  = scaledWidth*1;
    thumbnailRect.size.height = scaledHeight*1;

    sourceImage.drawInRect(thumbnailRect)

    newImage = UIGraphicsGetImageFromCurrentImageContext()
    if(newImage == nil){
      NSLog("could not scale image")
      print(scaleFactor)
      newImage = UIImage()
    }

    UIGraphicsEndImageContext();
    return newImage!
  }

  private func getResultImage() -> UIImage {
    let squareFrame = self.cropFrame;
    let scaleRatio = self.latestFrame.size.width / self.originalImage.size.width;
    var x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
    var y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
    var w = squareFrame.size.width / scaleRatio;
    var h = squareFrame.size.height / scaleRatio;
    if (self.latestFrame.size.width < self.cropFrame.size.width) {
      let newW = self.originalImage.size.width;
      let newH = newW * (self.cropFrame.size.height / self.cropFrame.size.width);
      x = 0; y = y + (h - newH) / 2;
      w = newW; h = newH;
    }
    if (self.latestFrame.size.height < self.cropFrame.size.height) {
      let newH = self.originalImage.size.height;
      let newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
      x = x + (w - newW) / 2; y = 0;
      w = newW; h = newH;
    }
    let myImageRect = CGRectMake(x, y, w, h);
    let imageRef = self.originalImage.CGImage;
    let subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    var size = CGSizeZero
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    let context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef)
    let smallImage = UIImage(CGImage: subImageRef!)
    UIGraphicsEndImageContext();
    return self.imageByScalingAndCroppingForSourceImage(smallImage, targetSize: CGSizeMake(cropSize.width*2, cropSize.height*2))
  }

  //MARK:- Actions
  @objc func onConformButtonPressed(sender:AnyObject?) {
    delegate?.imageCropperViewController(self, didFinished: self.getResultImage())
    self.navigationController?.popViewControllerAnimated(false)
    self.dismissViewControllerAnimated(false, completion: nil)
  }

  @objc func onCancelButtonPressed(sender:AnyObject?) {
    delegate?.imageCropperDidCancel(self)
    self.navigationController?.popViewControllerAnimated(false)
    self.dismissViewControllerAnimated(false, completion: nil)
  }
  
}
