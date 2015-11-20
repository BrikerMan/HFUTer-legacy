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
}
