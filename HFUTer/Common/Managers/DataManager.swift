//
//  DataManager.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/21.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
private let key = "THIS IS THE KEY"

class DataManager {
  class func getJpgFileName() -> String{
    let timeStamp = NSDate().timeIntervalSince1970 * 1000
    return MD5Encryption.md5by32("\(timeStamp)") + ".jpg"
  }

  class func encode(str:String) -> String {
    return DESEncryption.encryptUseDES(str, key: key)
  }

  class func decode(str:String) -> String {
    let decryptedStr =  DESEncryption.decryptUseDES(str, key: key)
    if decryptedStr == nil {
      return ""
    } else {
      return decryptedStr
    }
  }

  class func encodeUserData(user:EduUser,password:String) -> String {
    let charList = ["1","2","3","4","5","6","7","8","9","0","a","b","c","d","e","f"]
    var key = ""
    for _ in 0...7 {
      let diceFaceCount: UInt32 = 16
      let index = Int(arc4random_uniform(diceFaceCount))
      key += (charList[index])
    }
    let md5Pass = MD5Encryption.md5by32(password)
    let initalData = user.username + " " + md5Pass + " " + user.name + " " + user.gender + " " + user.academy + " " + user.className + " " + user.schoolYard.lowercaseString

    return DESEncryption.encryptUseDES(initalData, key: key) + key
  }

}