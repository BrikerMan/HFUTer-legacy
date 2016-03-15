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
   
    // 底部
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var inputFieldBackView: UIView!
    @IBOutlet weak var bottomViewButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var isFinishedPushAnimation = false
    
    var model:EECommunityLoveWallModel!
    var firstCell:BCMassageLoveTableViewCell?
    private var commentList = [EECommunityLoveCommentModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "表白详情"
        let nib1 = UINib(nibName: "HFLoveWallHeaderCell", bundle: nil)
        let nib2 = UINib(nibName: "HFLoveWallCommentCell", bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: "HFLoveWallHeaderCell")
        tableView.registerNib(nib2, forCellReuseIdentifier: "HFLoveWallCommentCell")
        
        self.view.backgroundColor = Color.getGradientColor()
        tableView.backgroundColor = UIColor.clearColor()
        
        bottomView.backgroundColor = UIColor.whiteColor()
        bottomView.alpha = 0
        
        likeButton.layer.cornerRadius = 3
        likeButton.layer.borderColor  = UIColor(hexString: "#dfdfdf").CGColor
        likeButton.layer.borderWidth = 1
        
        inputFieldBackView.layer.cornerRadius = 3
        inputFieldBackView.layer.borderColor  = UIColor(hexString: "#dfdfdf").CGColor
        inputFieldBackView.layer.borderWidth = 1
        
        NotifCenter.addObserver(self, selector: "keyBoardWillShowOrHideAnimation:", name: UIKeyboardWillShowNotification, object: nil)
        NotifCenter.addObserver(self, selector: "keyBoardWillShowOrHideAnimation:", name: UIKeyboardWillHideNotification, object: nil)
        
        likeCountLabel.text = "\(model.favoriteCount)"
        commentTextField.delegate = self
        
        self.getCommentList()
        
        animateStart()
    }
    
    //MARK:- 动画
    @objc private func keyBoardWillShowOrHideAnimation(notification:NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                self.bottomViewButtonConstraint.constant = keyboardHeight
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    private func animateStart() {
        self.isFinishedPushAnimation = true
        self.tableView.reloadData()
        //BottomView
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.bottomView.alpha = 1
            }, completion: nil)
        
    }
    
    private func getCommentList() {
        Hud.showLoading("正在加载评论")
        EECommunityLoveCommentModel.getModelsFromNetWorkForPage(0, model_id: model.id) { (error, models) -> () in
            if let models = models {
                self.commentList.appendContentsOf(models.reverse())
                self.tableView.reloadData()
                Hud.dismiss()
            } else {
                Hud.showError(error)
            }
        }
    }
    
    @IBAction func onReplyButtonpPressed(sender: AnyObject) {
        let vc = BCReplyCommentController(nib: "BCReplyCommentController")
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil)
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


extension BCLoveWallDetailViewController:UITextFieldDelegate {

        func textFieldShouldReturn(textField: UITextField) -> Bool {
            let text = (textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
            if text.characters.count > 0 {
               
                return true
            }
            return false
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
            if let json = try? NSJSONSerialization.dataWithJSONObject([to], options: NSJSONWritingOptions.init(rawValue: 0)) {
                let jsonString = NSString(data: json, encoding: NSUTF8StringEncoding)
                params["at"] = jsonString
            }
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
            let cell = tableView.dequeueReusableCellWithIdentifier("HFLoveWallHeaderCell", forIndexPath: indexPath) as! HFLoveWallHeaderCell
            //      firstCell = cell
            cell.selectionStyle = .None
            if !isFinishedPushAnimation {
                cell.hidden = true
            }
            cell.setupWithModel(self.model, index: 0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("HFLoveWallCommentCell", forIndexPath: indexPath) as! HFLoveWallCommentCell
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
            vc.to = self.commentList[indexPath.row].uid
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return HFLoveWallHeaderCell.getHeight(self.model)
        } else {
            return HFLoveWallCommentCell.getHightForModel(self.commentList[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //    if indexPath.section == 1 {
        cell.alpha = 0
        let y:CGFloat = 0
        //      if let cell = firstCell {
        //        y = cell.frame.origin.y + cell.frame.size.height/2
        //      }
        
        let original = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)
        cell.frame = CGRectMake(cell.frame.origin.x, y, cell.frame.size.width, cell.frame.size.height)
        UIView.animateWithDuration(0.5) {
            cell.alpha = 1
            cell.frame = original
        }
    }
    //  }
}
