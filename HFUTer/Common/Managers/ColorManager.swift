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
			PlistManager.shared().saveTintColor(primaryTintColor)
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
	
	var colorDicForKeys:[String:String] {
		didSet {
			PlistManager.shared().saveColorDic(colorDicForKeys)
		}
	}
	
	init() {
		primaryTintColor      = UIColor ( red: 0.886, green: 0.231, blue: 0.2693, alpha: 1.0 )
		colorArray            = NSArray(ofColorsWithColorScheme: ColorScheme.Analogous, usingColor: primaryTintColor, withFlatScheme: true)
		secondaryTintColor    = colorArray[0] as! UIColor
		colorDicForKeys       = PlistManager.shared().readColorDic()
	}
	
	func getRandomFlatColorForCode(code:String) -> UIColor {
		if let colorCode = colorDicForKeys[code] {
			var color = UIColor.whiteColor()
			for flatColor in colorDic {
				if colorCode == flatColor.name {
					color = flatColor.color
				}
			}
			return color
		} else {
			var list = colorDic
			let index = Int(arc4random_uniform(UInt32(list.count)))
			colorDicForKeys[code] = list[index].0
			return list[index].1
		}
	}
	
	func saveColorNameForCode(colorName name:String, code:String?) {
		if let code = code {
		colorDicForKeys[code] = name
		}
	}
	
	
	func getGradientColor() -> UIColor {
		//    let frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
		//    let color = GradientColor(.Radial, frame: frame, colors: [UIColor.blackColor().ultraLight(),Color.primaryTintColor.ultraLight()])
//		return Color.primaryTintColor.lightenByPercentage(0.5)
        return UIColor.groupTableViewBackgroundColor()
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
