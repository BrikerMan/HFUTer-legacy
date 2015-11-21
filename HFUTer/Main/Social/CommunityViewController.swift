//
//  CommunityViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class CommunityViewController: EEBaseViewController {


  @IBOutlet weak var scrollView: UIScrollView!


  private var lostView:MassageLostListView!

  // 状态和数据
  private var isShowingActionView = false
  private var isShowingleaveContectInfoView = false
  private var playgroundPage = 0
  private var loveWallListPage = 0

  private var lostAndFindList = [BCLostAndFoundModel]()
  //  private var loveWallModels = [BCMassageLoveWallModel]()
  private var choosedIndex = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "社区"
    initScrollView()
    getDateFromServer()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }



  //MARK:- 网络请求
  func getDateFromServer() {
    let url = getComURL("api/lostFound/getList")
    let params = [
      "pageIndex":playgroundPage
    ]

    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
      onFinishedBlock: { (response) -> Void in
        let json = JSONND.init(dictionary:response as! [String : AnyObject])
        if let array = json["data"].array {
          for json in array {
            let model = BCLostAndFoundModel(JSONNDObject: json)
            model.pic = BCLostAndFoundModel.getPicList(json)
            self.lostAndFindList.append(model)
          }
          if array.count == 0 {
            self.lostView.endLoadMoreRefreshing(false)
          } else {
            self.lostView.endLoadMoreRefreshing(true)
          }
        }
        self.lostView.initModelList(self.lostAndFindList)
      }, onFailedBlock: { (reason) -> Void in
        Hud.showError(reason)
      }, onNetErrorBlock: {() -> Void in
        Hud.showMassage(NetErrorWarning)
    })
  }
  //
  //  func getLoveWallDataRequest() {
  //    let url = "http://hfut.cn-hangzhou.aliapp.com/api/confession/list"
  //    let params = [
  //      "pageIndex":loveWallPage
  //    ]
  //    BCBaseRequest.getJsonFromServerRequest(url, params: params,
  //      onFinishedBlock: { (response) -> Void in
  //        let json = JSONND.init(dictionary:response as! [String : AnyObject])
  //        if let array = json["data"].array {
  //          for json in array {
  //            let model = BCMassageLoveWallModel(JSONNDObject: json)
  //            self.loveWallModels.append(model)
  //          }
  //          if array.count == 0 {
  //            self.loveWallView.endLoadMoreRefreshing(false)
  //          } else {
  //            self.loveWallView.endLoadMoreRefreshing(true)
  //          }
  //        }
  //        self.loveWallView.iniModelList(self.loveWallModels)
  //      }, onFailedBlock: { (reason) -> Void in
  //        HUD.showError(reason)
  //      }) { () -> () in
  //        HUD.showMassage("网络错误，请稍候再试")
  //    }
  //
  //  }
  //
  //  func likeLoveWallRequest(index:Int) {
  //    let url = "http://hfut.cn-hangzhou.aliapp.com/api/confession/good"
  //    let params = [
  //      "id":self.loveWallModels[index].id
  //    ]
  //    BCBaseRequest.getJsonFromServerRequest(url, params: params,
  //      onFinishedBlock: { (response) -> Void in
  //
  //      }, onFailedBlock: { (reason) -> Void in
  //
  //      }) { () -> Void in
  //
  //    }
  //  }


  func initScrollView() {
    self.scrollView.pagingEnabled = true
    self.scrollView.showsHorizontalScrollIndicator = false
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 2, scrollView.frame.size.height);
    self.scrollView.delegate = self

    self.scrollView.backgroundColor = Color.primaryTintColor.ultraLight()

    lostView = MassageLostListView()
    self.scrollView.addSubview(lostView)
    lostView.delegate = self

    lostView.snp_makeConstraints(closure: { (make) -> Void in
      make.top.equalTo(self.scrollView.snp_top)
      make.left.equalTo(self.scrollView.snp_left)
      make.width.equalTo(self.scrollView.snp_width)
      make.height.equalTo(self.scrollView.snp_height)
    })

    let loveWallView = UIView()
    self.scrollView.addSubview(loveWallView)
    //    loveWallView.delegate = self

    loveWallView.snp_makeConstraints(closure: { (make) -> Void in
      make.top.equalTo(self.scrollView.snp_top)
      make.left.equalTo(self.scrollView.snp_left).offset(ScreenWidth)
      make.width.equalTo(self.scrollView.snp_width)
      make.height.equalTo(self.scrollView.snp_height)
    })
  }
}

// MARK :- MassageLostListViewDelegate
extension CommunityViewController:MassageLostListViewDelegate {
  func MassageLostListRefresh() {
    self.lostAndFindList.removeAll()
    playgroundPage = 0
    getDateFromServer()
  }

  func MassageLostListLoadMore() {
    playgroundPage += 1
    getDateFromServer()
  }

  func MassageLostListReplyButtonPressed(index:Int) {
    //    runAfterLoginToCommunity { () -> () in
    //      self.choosedIndex = index
    //      self.showOrHideLeaveContectInfoView()
    //    }
  }

  func MassageLostListImagesPressed(imageLinks: [String],index:Int) {
    //    let vc = BCBaseImagesViewController()
    //    vc.page = index
    //    vc.imageLinks = imageLinks
    //    vc.dateSourse = .Link
    //    self.pushToViewController(vc)
  }
}

// MARK :- UIScrollViewDelegate
extension CommunityViewController:UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let page = UInt((scrollView.contentOffset.x)/ScreenWidth)
    //    segmentController.setSelectedSegmentIndex(page, animated: true)

  }
}
