//
//  InfoNewsDetailViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/23.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit
import Kanna

class InfoNewsDetailViewController: EEBaseViewController {
  
  private var newsDetailWebView: UIWebView!
  private var isGettingNewsDetail = false
  private var detailModel:NewsDetailModel!
  
  var newsModel:NewsListModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Color.primaryLightColor
    navTitle = "新闻详情"
    setUI()
    beganGetDetailRequest()
  }
  
  func passNewsModel(model:NewsListModel) {
    self.newsModel = model
  }
  
  private func beganGetDetailRequest() {
    if !isGettingNewsDetail {
      Hud.showLoading("正在获取新闻列表")
      isGettingNewsDetail = true
      let url = "http://hfut.cn-hangzhou.aliapp.com/news/newsDetail"
      let params = [
        "nid":newsModel.nid,
      ]
      BCBaseRequest.getJsonRequest(url, params: params,
        onFinishedBlock: { (response) -> Void in
          if let data = response["data"] as? NSDictionary {
            self.detailModel = NewsDetailModel()
            self.detailModel.title = data["title"] as! String
            self.detailModel.content = data["content"] as! String
            self.showContent()
          }
          self.isGettingNewsDetail = false
        }) { (error) -> Void in
          self.isGettingNewsDetail = false
          Hud.showMassage("网络异常")
      }
    }
  }
  
  private func showContent() {
    var colorString = "#F96332"
    if let doc = HTML(html: self.detailModel.content, encoding: NSUTF8StringEncoding) {
      if let color = Color.primaryTintColor.light().RGBa {
        colorString = "rgba\(color)"
      }
      for body in doc.xpath("//div[@class='content f16']") {
        self.detailModel.content = body.innerHTML!
        let header = "<html><head></head><style> img {max-width: 100%;height: auto;}</style><body style='margin-left: 0px;margin-top: 0px;margin-right: 0px;'><div style='text-align: center;background-color: \(colorString);padding-bottom: 5px;padding-top: 10px;margin-left: 0px;margin-right: 0px;border-right-width: 0px;border-top-width: 0px;'><h3 style='color: white;margin-bottom: 0px;margin-top: 0px;'>\(newsModel.title)</h3><h5 style='color: white;margin-top: 10px;margin-bottom: 5px;'>\(newsModel.date)</h5></div><div style='margin-left: 8px;margin-right: 8px;'>"
        self.detailModel.content = header + self.detailModel.content + "</div></body></html>"
      }
    }
    Hud.dismiss()
    print(detailModel.content)
    self.newsDetailWebView.loadHTMLString(self.detailModel.content, baseURL: NSURL(string: "http://news.hfut.edu.cn"))
  }
  
  private func setUI() {
    newsDetailWebView = UIWebView()
    self.view.addSubview(newsDetailWebView)
    
    newsDetailWebView.snp_makeConstraints { (make) -> Void in
      make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0))
    }
  }
  
}
