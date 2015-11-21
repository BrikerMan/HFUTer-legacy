//
//  ColorManager.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

private let _SingletonASharedInstance = ColorManager()

class ColorManager {
  var colorDic = [String:UIColor]()

  //单例
  class func sharedManager() -> ColorManager {
    return _SingletonASharedInstance
  }

  //主色调
  var primaryTintColor      = UIColor ( red: 0.959, green: 0.3217, blue: 0.0593, alpha: 1.0 ) {
    didSet {
      NSNotificationCenter.defaultCenter().postNotificationName(BCChangeTintColorNotification, object: nil, userInfo: nil)
      PlistManager.saveTintColor(primaryTintColor)
    }
  }

  var secondaryTintColor    = UIColor ( red: 0.2824, green: 0.2118, blue: 0.149, alpha: 1.0 )

  var primaryDarkColor      = UIColor ( red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0 )
  var secondaryDarkColor    = UIColor ( red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0 )

  var primaryLightColor     = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )
  var secondaryLightColor   = UIColor ( red: 0.9508, green: 0.9507, blue: 0.9507, alpha: 1.0 )




  // Flat Colors
  var dodgerBlue = UIColor ( red: 0.098, green: 0.7098, blue: 0.9961, alpha: 1.0 )
  var spray = UIColor ( red: 0.5059, green: 0.8118, blue: 0.8784, alpha: 1.0 )
  var steelBlue = UIColor ( red: 0.2941, green: 0.4667, blue: 0.7451, alpha: 1.0 )
  var mediumTurquoise = UIColor ( red: 0.3059, green: 0.8039, blue: 0.7686, alpha: 1.0 )
  var madang = UIColor ( red: 0.9241, green: 0.5915, blue: 0.5603, alpha: 1.0 )
  var capeHoney = UIColor ( red: 0.2674, green: 0.6415, blue: 0.8153, alpha: 1.0 )
  var casablanca = UIColor ( red: 0.9569, green: 0.702, blue: 0.3137, alpha: 1.0 )
  var sunglo = UIColor ( red: 0.8863, green: 0.4157, blue: 0.4157, alpha: 1.0 )
  var purple = UIColor ( red: 0.4, green: 0.2, blue: 0.6, alpha: 1.0 )
  var newBlue = UIColor(red: 0.3421, green: 0.8221, blue: 0.2831, alpha: 1.0)

  func getRandomFlatColorForCode(code:String) -> UIColor {
    if let color = colorDic[code] {
      return color
    } else {
      var list = [newBlue,dodgerBlue,spray,steelBlue,mediumTurquoise,madang,capeHoney,casablanca,sunglo,purple,newBlue]
      let index = Int(arc4random_uniform(UInt32(list.count)))
      colorDic[code] = list[index]
      return list[index]
    }
  }

  /*
  Color.parseColor("#e91e63"),
  Color.parseColor("#9c27b0"),
  Color.parseColor("#673ab7"),
  Color.parseColor("#3f51b5"),
  Color.parseColor("#5677fc"),
  Color.parseColor("#03a9f4"),
  Color.parseColor("#00bcd4"),
  Color.parseColor("#009688"),
  Color.parseColor("#259b24"),
  Color.parseColor("#8bc34a"),
  Color.parseColor("#ff5722"),
  Color.parseColor("#795548"),
  Color.parseColor("#607d8b"),
  */

  private let color1 = UIColor.rgb(56, g:171, b:249)
  private let color2 = UIColor.rgb(224, g:237, b:196)
  private let color3 = UIColor.rgb(159, g:93, b:94)
  private let color4 = UIColor.rgb(34, g:208, b:211)
  private let color5 = UIColor.rgb(255, g:142, b:45)
  private let color6 = UIColor.rgb(249, g:155, b:211)
  private let color7 = UIColor.rgb(250, g:205, b:50)



  func getLoveWallColors(index:Int) -> UIColor{
    let colorList = [color1,color2,color3,color4,color5,color6,color7,color7,color1,color2,color3,color4,color5,color6,color7,color7]
    if index < colorList.count {
      return colorList[index]
    } else {
      return primaryTintColor
    }
  }
}
