//
//  BCLoveWallDetailViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/26.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCLoveWallDetailViewController: EEBaseViewController {
  
  @IBOutlet weak var tableView:UITableView!
  @IBOutlet weak var replyViewHeight: NSLayoutConstraint!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var commentButton: UIButton!
  
  var isFinishedPushAnimation = false
  
  var model:BCMassageLoveWallModel!
  var firstCell:BCMassageLoveTableViewCell?
  private var commentList = [BCMassageCommentModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navTitle = "表白详情"
    let nib1 = UINib(nibName: "BCMassageLoveTableViewCell", bundle: nil)
    let nib2 = UINib(nibName: "BCLoveWallDetailTableViewCell", bundle: nil)
    tableView.registerNib(nib1, forCellReuseIdentifier: "BCMassageLoveTableViewCell")
    tableView.registerNib(nib2, forCellReuseIdentifier: "BCLoveWallDetailTableViewCell")
    
    self.view.backgroundColor = UIColor.whiteColor()
    tableView.backgroundColor = Color.primaryTintColor.ultraLight()
    bottomView.backgroundColor = Color.primaryTintColor.ultraLight()
    bottomView.alpha = 0
    
    commentButton.setFAText(prefixText: "", icon: .FACommentsO, postfixText: " 评论", size: 15, forState: UIControlState.Normal)
    likeButton.setFAText(prefixText: "", icon: .FAHeartO, postfixText: " 赞", size: 15, forState: UIControlState.Normal)
    self.getCommentList()

    animateStart()
  }
  
  func animateStart() {
    self.isFinishedPushAnimation = true
    self.tableView.reloadData()
    //BottomView
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
      self.bottomView.alpha = 1
      }, completion: nil)
    
  }
  
  private func getCommentList() {
    Hud.showLoading("正在加载评论")
    let url = "http://hfut.cn-hangzhou.aliapp.com/api/confession/commentList"
    let params = [
      "pageIndex":0,
      "id":model.id
    ]
    
    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
      onFinishedBlock: { (response) -> Void in
        let json = JSONND.init(dictionary:response as! [String : AnyObject])
        if let array = json["data"].array {
          for json in array {
            let model = BCMassageCommentModel(JSONNDObject: json)
            self.commentList.append(model)
          }
        }
        Hud.dismiss()
        self.tableView.reloadData()
      }, onFailedBlock: { (reason) -> Void in
        Hud.showError(reason)
      }) { () -> Void in
        Hud.showError("网络错误，请稍候尝试")
    }
  }
  
  @IBAction func onReplyButtonpPressed(sender: AnyObject) {
//    if replyTextView.text.characters.count < 5 {
//      Hud.showMassage("请输入超过5个字符的评论")
//      return
//    }
//    self.sendCommentList(replyTextView.text)
  }
  
  @IBAction func onLikeButtonPressed(sender: AnyObject) {
    let url = "http://hfut.cn-hangzhou.aliapp.com/api/confession/good"
    let params = [
      "id":self.model.id
    ]
    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
      onFinishedBlock: { (response) -> Void in
        self.model.favorite = true
        self.model.favoriteCount += 1
        self.tableView.reloadData()
      }, onFailedBlock: { (reason) -> Void in
        Hud.showError(reason)
      }) { () -> Void in
        Hud.showError("网络错误，请稍候尝试")
        
    }
  }
  
  
  private func sendCommentList(params:[String : AnyObject]) {
    Hud.showLoading("正在发表评论")
    let url = "http://hfut.cn-hangzhou.aliapp.com/api/confession/comment"

    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
      onFinishedBlock: { (response) -> Void in
        self.commentList.removeAll()
        self.getCommentList()
        Hud.dismiss()
      }, onFailedBlock: { (reason) -> Void in
        Hud.showError(reason)
      }) { () -> Void in
        Hud.showError("网络错误，请稍候尝试")
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}


extension BCLoveWallDetailViewController:BCReplyCommentControllerDelegate {
  func replyCommentControllerDidReply(commend: String, anonymously: Bool, to: Int) {
    var params:[String:AnyObject] = [
      "content":commend,
      "id":model.id,
      "anonymous":anonymously,
    ]
    if to != 0  {
      params["at"] = [to]
    }
    
    self.sendCommentList(params)
  }
}

//MARK:- UITableViewDataSource
extension BCLoveWallDetailViewController:UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      if isFinishedPushAnimation {
        return self.commentList.count
      } else {
        return 0
      }
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("BCMassageLoveTableViewCell", forIndexPath: indexPath) as! BCMassageLoveTableViewCell
      firstCell = cell
      cell.selectionStyle = .None
      if !isFinishedPushAnimation {
        cell.hidden = true
      }
      cell.setupWithModel(self.model, index: 0)
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("BCLoveWallDetailTableViewCell", forIndexPath: indexPath) as! BCLoveWallDetailTableViewCell
      cell.setupWithModel(self.commentList[indexPath.row])
      return cell
    }
  }
}

//MARK:- UITableViewDelegate
extension BCLoveWallDetailViewController:UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 0 {
      tableView.deselectRowAtIndexPath(indexPath, animated: false)
    } else {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      let vc = BCReplyCommentController(nib: "BCReplyCommentController")
      vc.delegate = self
      if self.commentList[indexPath.row].id != 0 {
        vc.to = self.commentList[indexPath.row].id
      }
      self.presentViewController(vc, animated: true, completion: nil)
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return BCMassageLoveTableViewCell.getHeightForModel(self.model)
    } else {
      return BCLoveWallDetailTableViewCell.getHightForModel(self.commentList[indexPath.row])
    }
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 1 {
      cell.alpha = 0
      var y:CGFloat = 100.0
      if let cell = firstCell {
        y = cell.frame.origin.y + cell.frame.size.height/2
      }
      
      let original = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)
      cell.frame = CGRectMake(cell.frame.origin.x, y, cell.frame.size.width, cell.frame.size.height)
      UIView.animateWithDuration(0.5) {
        cell.alpha = 1
        cell.frame = original
      }
    }
  }
}
