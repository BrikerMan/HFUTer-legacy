//
//  BCExtensions.swift
//  HFUTer2
//
//  Created by Eliyar Eziz on 15/11/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import UIKit

//字符串截断方法
extension String {
  func getIndexsOf(char:Character) -> [Int]{
    var i = 0
    var index = [0]
    for character in self.characters {
      if character == char {
        index.append(i)
      }
      i += 1
    }
    return index
  }

  func getIndexOf(char:Character) -> Int{
    var index = 0
    for character in self.characters {
      if character == char {
        return index
      }
      index += 1
    }
    return 0
  }

  subscript(r:Range<Int>) -> String {
    get {
      let startIndex = self.startIndex.advancedBy(r.startIndex)
      let endIndex = self.startIndex.advancedBy(r.endIndex)
      if startIndex >= endIndex {
        return ""
      }
      return self[Range(start: startIndex, end: endIndex)]
    }
  }

  func seperateBy(char:Character) -> [String] {
    var result = [String]()
    var index = 0
    var lastIndex = 0
    for character in self.characters {
      if character == char {
        result.append(self[lastIndex+1..<index])
        lastIndex = index
      }
      index += 1
    }
    result.append(self[lastIndex..<self.characters.count])
    return result
  }

  func seperateBy2(char:Character) -> [String] {
    var result = [String]()
    var index = 0
    var lastIndex = 0
    for character in self.characters {
      if character == char {
        result.append(self[lastIndex..<index])
        lastIndex = index
      }
      index += 1
    }
    result.append(self[lastIndex..<self.characters.count])
    return result
  }

  func getStringBetween(char1:Character,char2:Character) -> String {
    var start = 0
    var end = 0
    var index = 0
    for character in self.characters {
      if character == char1 {
        start = index
      }
      if character == char2 {
        end = index
      }
      index += 1
    }
    if end > start {
      return self[start..<end]
    } else {
      return ""
    }
  }

  //判断是否包含某个字符
  func contains(find: String) -> Bool{
    return self.rangeOfString(find) != nil
  }

  //获取Array
  func getArray() -> [Int]{
    var result = [Int]()
    let seperated = self.seperateBy2(",")
    for sep in seperated {
      if sep.characters.contains(",") {
        if let num = Int(sep[1..<sep.characters.count].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())) {
          result.append(num)
        }
      } else {
        if let num = Int(sep.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())) {
          result.append(num)
        }
      }
    }
    return result
  }

}

//十六进制产生颜色

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")

    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }

  convenience init(netHex:Int) {
    self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
  }

  class func rgb(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor{
    let red = r/255
    let green = g/255
    let blue = b/255
    return UIColor(red: red, green: green, blue: blue, alpha: 1)
  }

}

extension UIColor {
  convenience init(hex: Int, alpha: CGFloat) {
    let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
    let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
    let b = CGFloat(hex & 0x0000FF) / 255.0
    self.init(red: r, green: g, blue: b, alpha: alpha)
  }
  convenience init(hexString str: String, alpha: CGFloat) {
    let range = NSMakeRange(0, (str.characters.count))
    let hex = (str as NSString).stringByReplacingOccurrencesOfString("[^0-9a-fA-F]", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: range)
    var color: UInt32 = 0
    NSScanner(string: hex).scanHexInt(&color)
    self.init(hex: Int(color), alpha: alpha)
  }

  var hexString: String? {
    return self.CGColor.hexString
  }
  var RGBa: (red: Int, green: Int, blue: Int, alpha: CGFloat)? {
    return self.CGColor.RGBa
  }

  func light() -> UIColor {
    return self.colorWithAlphaComponent(colorAlphaComponent)
  }

  func ultraLight() -> UIColor {
    return self.colorWithAlphaComponent(0.2)
  }
}

extension CGColor {
  var hexString: String? {
    if let x = self.RGBa {
      let hex = x.red * 0x10000 + x.green * 0x100 + x.blue
      return NSString(format:"%06x", hex) as String
    } else {
      return nil
    }
  }
  var RGBa: (red: Int, green: Int, blue: Int, alpha: CGFloat)? {
    //    let colorSpace = CGColorGetColorSpace(self)
    //    let colorSpaceModel = CGColorSpaceGetModel(colorSpace)
    //    if colorSpaceModel.hashValue == 1 {
    let x = CGColorGetComponents(self)
    let r: Int = Int(x[0] * 255.0)
    let g: Int = Int(x[1] * 255.0)
    let b: Int = Int(x[2] * 255.0)
    let a: CGFloat = x[3]
    return (r, g, b, a)
    //    } else {
    //      return nil
    //    }
  }
}
