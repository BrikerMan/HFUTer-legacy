//
//  Utilities.swift
//  Hande
//
//  Created by Eliyar Eziz on 15/11/17.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class Utilities {

  class func getJPGPicName() -> String {
    let timeStamp = NSDate().timeIntervalSince1970 * 100000
    return "\(timeStamp).jpg"
  }

  class func getLabelHeightWithFontSize(content:String,font:UIFont,width:CGFloat) -> CGFloat {
    let attributes = [NSFontAttributeName: font]//字体和大小
    let frame = content.boundingRectWithSize(CGSizeMake(width, CGFloat.max),options: NSStringDrawingOptions.UsesLineFragmentOrigin,attributes: attributes,context: nil)
    return frame.size.height
  }

  class func getTimeStringFromTimeStamp(stm:Int) -> String {
    let timeInterval:NSTimeInterval = Double(stm)
    let time = NSDate().timeIntervalSince1970
    let formatter = NSDateFormatter()
    let date = NSDate(timeIntervalSince1970: timeInterval)
    formatter.dateFormat = "yyyy年M月d日"
    let todayStr = formatter.stringFromDate(NSDate())
    let todayStamp = formatter.dateFromString(todayStr)!.timeIntervalSince1970
    
    let sec =  Int(time - timeInterval)
    if sec < 60 {
      return "\(sec)秒前"
    }
    
    let min:Int = Int(sec/60)
    if min < 60 {
      return "\(min)分钟前"
    }
    
    let hour:Int = Int(min/60)
    
    //判断是否是今天昨天
    if timeInterval > todayStamp {
      formatter.dateFormat = "hh:mm"
    } else if timeInterval > todayStamp - 86400 {
      formatter.dateFormat = "昨天 hh:mm"
    } else if hour < 24 * 365 {
      formatter.dateFormat = "M-d hh:mm"
    } else {
      formatter.dateFormat = "yyyy-M-d hh:mm"
    }
    
    let dateStr = formatter.stringFromDate(date)
    return dateStr
  }
	
	class func getFullTimeStringFromTimeStamp(stm:Int) -> String {
		let timeInterval:NSTimeInterval = Double(stm)
		let formatter = NSDateFormatter()
		let date = NSDate(timeIntervalSince1970: timeInterval)
		formatter.dateFormat = "yyyy-M-d HH:MM"
		let dateStr = formatter.stringFromDate(date)
		return dateStr
	}
	
	
  class func getTimeString(stm:Int64) -> String {
    let timeInterval:NSTimeInterval = Double(stm/1000)
    let time = NSDate().timeIntervalSince1970
    let formatter = NSDateFormatter()
    let date = NSDate(timeIntervalSince1970: timeInterval)
    formatter.dateFormat = "yyyy年M月d日"
    let todayStr = formatter.stringFromDate(NSDate())
    let todayStamp = formatter.dateFromString(todayStr)!.timeIntervalSince1970

    let sec =  Int(time - timeInterval)
    if sec < 60 {
      return "\(sec)秒前"
    }

    let min:Int = Int(sec/60)
    if min < 60 {
      return "\(min)分钟前"
    }

    let hour:Int = Int(min/60)

    //判断是否是今天昨天
    if timeInterval > todayStamp {
      formatter.dateFormat = "hh:mm"
    } else if timeInterval > todayStamp - 86400 {
      formatter.dateFormat = "昨天 hh:mm"
    } else if hour < 24 * 365 {
      formatter.dateFormat = "M-d hh:mm"
    } else {
      formatter.dateFormat = "yyyy-M-d hh:mm"
    }

    let dateStr = formatter.stringFromDate(date)
    return dateStr
  }

  class func getTimeStringForLoveWall(stm:Int) -> String {
    let timeInterval:NSTimeInterval = Double(stm)
    let time = NSDate().timeIntervalSince1970
    let formatter = NSDateFormatter()
    let date = NSDate(timeIntervalSince1970: timeInterval)
    formatter.dateFormat = "yyyy年M月d日"
    let todayStr = formatter.stringFromDate(NSDate())
    let todayStamp = formatter.dateFromString(todayStr)!.timeIntervalSince1970

    let sec =  Int(time - timeInterval)
    if sec < 60 {
      return "\(sec)秒前"
    }

    let min:Int = Int(sec/60)
    if min < 60 {
      return "\(min)分钟前"
    }

    let hour:Int = Int(min/60)

    //判断是否是今天昨天
    if timeInterval > todayStamp {
      formatter.dateFormat = "今天\nhh:mm"
    } else if timeInterval > todayStamp - 86400 {
      formatter.dateFormat = "昨天\nhh:mm"
    } else if hour < 24 * 365 {
      formatter.dateFormat = "M月d\nhh:mm"
    } else {
      formatter.dateFormat = "yy年M月d\nhh:mm"
    }

    let dateStr = formatter.stringFromDate(date)
    return dateStr
  }
	

}