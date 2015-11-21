//
//  BCColorChooseView.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/16.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit


class BCColorChooseView:EEXibView {
  
  var dismissBlock:(()->())?
  
  @IBOutlet weak var colorPreviewView: UIView!
  
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  
  @IBOutlet weak var redLabel: UILabel!
  @IBOutlet weak var greenLabel: UILabel!
  @IBOutlet weak var blueLabel: UILabel!
  
  
  private var redValue:Float    = 100 {
    didSet {
      redLabel.text = "\(Int(redValue))"
    }
  }
  private var greenValue:Float  = 100{
    didSet {
      greenLabel.text = "\(Int(greenValue))"
    }
  }
  private var blueValue:Float   = 100{
    didSet {
      blueLabel.text = "\(Int(blueValue))"
    }
  }
  
  override func initFromXib() {
    super.initFromXib()
    if let rgba = Color.primaryTintColor.RGBa {
      redValue = Float(rgba.red)
      greenValue = Float(rgba.green)
      blueValue = Float(rgba.blue)
    }
    
    redSlider.value   = redValue
    greenSlider.value = greenValue
    blueSlider.value  = blueValue
    
    colorPreviewView.backgroundColor = UIColor(red: CGFloat(redValue/255), green: CGFloat(greenValue/255), blue: CGFloat(blueValue/255), alpha: 1)
  }
  
  @IBAction func onSliderValueChanged(sender: AnyObject) {
    if let sender = sender as? UISlider {
      if sender.tag == 0 {
        redValue = sender.value
      } else if sender.tag == 1 {
        greenValue = sender.value
      } else {
        blueValue = sender.value
      }
      colorPreviewView.backgroundColor = UIColor(red: CGFloat(redValue/255), green: CGFloat(greenValue/255), blue: CGFloat(blueValue/255), alpha: 1)
    }
  }
  
  @IBAction func onSaveButtonPressed(sender: AnyObject) {
    Color.primaryTintColor = colorPreviewView.backgroundColor!
    dismissBlock?()
  }
  
  @IBAction func onCancelButtonPressed(sender: AnyObject) {
    dismissBlock?()
  }
  
}