//
//  ColorManager.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import ChameleonFramework

private let _SingletonASharedInstance = ColorManager()

class ColorManager {
  //单例
  class func sharedManager() -> ColorManager {
    return _SingletonASharedInstance
  }
  
  //主色调
  var primaryTintColor      = UIColor ( red: 0.886, green: 0.231, blue: 0.2693, alpha: 1.0 ) {
    didSet {
      let colorArray =  NSArray(ofColorsWithColorScheme: ColorScheme.Analogous, usingColor: primaryTintColor, withFlatScheme: true)
      secondaryTintColor    = colorArray[0] as! UIColor
      NSNotificationCenter.defaultCenter().postNotificationName(BCChangeTintColorNotification, object: nil, userInfo: nil)
      PlistManager.saveTintColor(primaryTintColor)
    }
  }
  
  var colorArray =  NSArray(ofColorsWithColorScheme: ColorScheme.Analogous, usingColor: UIColor ( red: 0.886, green: 0.231, blue: 0.2693, alpha: 1.0 ), withFlatScheme: true)
  var secondaryTintColor    = UIColor ( red: 0.886, green: 0.231, blue: 0.2693, alpha: 1.0 )
  
  var primaryDarkColor      = UIColor ( red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0 )
  var secondaryDarkColor    = UIColor ( red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0 )
  
  var primaryLightColor     = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )
  var secondaryLightColor   = UIColor ( red: 0.9508, green: 0.9507, blue: 0.9507, alpha: 1.0 )
  
  // Flat Colors
  let colorDic:[(name:String,color:UIColor)] = [
    ("Green",FlatGreen()),
    ("Red",FlatRed()),
    ("Blue",FlatBlue()),
    ("Brown",FlatBrown()),
    ("Coffee",FlatCoffee()),
    ("ForestGreen",FlatForestGreen()),
    ("Lime",FlatLime()),
    ("Marnoon",FlatMaroon()),
    ("Mint",FlatMint()),
    ("Pink",FlatPink()),
    ("Teal",FlatTeal()),
    ("Orange",FlatOrange()),
    ("Purple",FlatPurple()),
    ("Plum",FlatPlum()),
    ("WaterLemon",FlatWatermelon()),
    ("SkyBlue",FlatSkyBlue()),
    ("Magenta",FlatMagenta()),
    ("NavyBlue",FlatNavyBlue()),
  ]
  
  var colorDicForKeys = [String:UIColor]()
  
  init() {
    primaryTintColor      = UIColor ( red: 0.886, green: 0.231, blue: 0.2693, alpha: 1.0 )
    colorArray            = NSArray(ofColorsWithColorScheme: ColorScheme.Analogous, usingColor: primaryTintColor, withFlatScheme: true)
    secondaryTintColor    = colorArray[0] as! UIColor
  }
  
  func getRandomFlatColorForCode(code:String) -> UIColor {
    if let color = colorDicForKeys[code] {
      return color
    } else {
      var list = colorDic
      let index = Int(arc4random_uniform(UInt32(list.count)))
      colorDicForKeys[code] = list[index].1
      return list[index].1
    }
  }
  
  /*
  private var color1 = UIColor(hexString: "#e91e63", alpha: 1.0)
  private let color2 = UIColor(hexString: "#9c27b0", alpha: 1.0)
  private let color3 = UIColor(hexString: "#673ab7", alpha: 1.0)
  private let color4 = UIColor(hexString: "#3f51b5", alpha: 1.0)
  private let color5 = UIColor(hexString: "#5677fc", alpha: 1.0)
  
  private let color6 = UIColor(hexString: "#03a9f4", alpha: 1.0)
  private let color7 = UIColor(hexString: "#00bcd4", alpha: 1.0)
  private let color8 = UIColor(hexString: "#009688", alpha: 1.0)
  private let color9 = UIColor(hexString: "#259b24", alpha: 1.0)
  private let color10 = UIColor(hexString: "#8bc34a", alpha: 1.0)
  
  private let color11 = UIColor(hexString: "#ff5722", alpha: 1.0)
  private let color12 = UIColor(hexString: "#795548", alpha: 1.0)
  private let color13 = UIColor(hexString: "#607d8b", alpha: 1.0)
  */
  
  
  func getGradientColor() -> UIColor {
    let frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
    let color = GradientColor(.Radial, frame: frame, colors: [UIColor.whiteColor(),Color.primaryTintColor.ultraLight()])
    return color
  }
  
  func getLoveWallColors(index:Int) -> UIColor{
    if index == 0 {
      return FlatSkyBlue()
    } else if index == 1 {
      return FlatPink()
    }
    return primaryTintColor
  }
}
