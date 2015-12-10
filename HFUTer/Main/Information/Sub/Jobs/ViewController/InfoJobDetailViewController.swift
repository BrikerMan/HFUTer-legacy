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
    webView.delegate = self
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
          let table = node.innerHTML ?? ""
            let header = "<!DOCTYPE html><html><head><meta charset='utf-8'/><style>img{display:none} .jzxx_2{font-size:12px;color:#036;line-height:30px;margin:0;margin-left:10px;text-align:right;width:100px} .jzxx_1{font-size:12px;color:#1B1B1B;line-height:30px;margin:0;margin-left:10pxborder-bottom-color: #eeeeee;border-bottom-width: 1px;border-bottom-style: dotted;} .jzxx_3{font-size:14px;color:#036;line-height:25px;font-weight:600;margin:2px;margin-left:10px}</style></head><body><table>"
          
          let footer = "</table></body></html>"
          self.htmlString = header + table + footer
        }
      }
    }
  }
}

extension InfoJobDetailViewController:UIWebViewDelegate {
  func webViewDidFinishLoad(webView: UIWebView) {
    let yourHTMLSourceCodeString = self.webView.stringByEvaluatingJavaScriptFromString("document.documentElement.outerHTML")
    print(yourHTMLSourceCodeString)
  }
}
