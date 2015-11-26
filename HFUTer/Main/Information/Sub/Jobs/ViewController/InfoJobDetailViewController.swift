//
//  InfoJobDetailViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/24.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Kanna

class InfoJobDetailViewController: EEBaseViewController {
  
  var model = InfoJobModel()
  
  @IBOutlet weak var webView: UIWebView!
  
  private var htmlString = ""
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "兼职详情"
    getDataFromWeb()
  }
  
  
  
  
  func getDataFromWeb() {
    let url = "http://job.hfut.edu.cn/" + model.link
    Hud.showLoading("正在加载")
    BCBaseRequest.getDataFromWebRequest(url, params: nil, onFinishedBlock: { (operation) -> Void in
      self.parseRequest(operation.data)
      Hud.dismiss()
      self.webView.loadHTMLString(self.htmlString, baseURL: nil)
      }) { (operation) -> Void in
        Hud.showError("出现错误")
    }
  }
  
  
  //TODO: 美化兼职详情
  func parseRequest(data:NSData?) {
    let enc = CFStringConvertEncodingToNSStringEncoding(0x0632)
    if let htmlString:String = NSString(data:data!, encoding: enc) as? String{
      if let doc = HTML(html: htmlString, encoding: NSUTF8StringEncoding) {
        for node in doc.xpath("//*[@id='zhuce_t']/table") {
          self.htmlString = node.innerHTML ?? ""
        }
      }
    }
  }
}
