//
//  PersonHelpViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/30.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

enum PersonHelpViewControllerStyle {
  case Help
  case PrivacyPoicy
  case AboutUs
}


class PersonHelpViewController: EEBaseViewController {
  
  var style = PersonHelpViewControllerStyle.Help
  private var url = ""
  
  @IBOutlet weak var webView: UIWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navBar.navLeftButtonStyle = .Back
    //TODO: 修改链接
    switch style {
    case .Help:
      navTitle = "帮助"
      url = "http://7xlrpg.com1.z0.glb.clouddn.com/help/ios-index.html"
    case .PrivacyPoicy:
      navTitle = "隐私条款"
      url = "http://7xlrpg.com1.z0.glb.clouddn.com/help/ios-index.html"
    case .AboutUs:
      navTitle = "关于我们"
      url = "http://7xlrpg.com1.z0.glb.clouddn.com/help/ios-index.html"
    }
    
    loadHtml()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  private func loadHtml() {
    Hud.showLoading("正在加载")
    let url = "http://7xlrpg.com1.z0.glb.clouddn.com/help/ios-index.html"
    BCBaseRequest.getDataFromWebRequest(url, params: nil, onFinishedBlock: { (operation) -> Void in
      if let data = operation.data, html = NSString(data: data, encoding: NSUTF8StringEncoding) as? String{
        self.webView.loadHTMLString(html, baseURL: nil)
        Hud.dismiss()
      } else {
        Hud.showError("数据错误")
      }
      }) { (operation) -> Void in
        Hud.showError(operation.error?.localizedDescription)
    }
  }
}
