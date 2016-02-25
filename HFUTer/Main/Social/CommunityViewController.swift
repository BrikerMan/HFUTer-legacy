//
//  CommunityViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/20.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import DGRunkeeperSwitch

class CommunityViewController: EEBaseViewController {
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	private var loveWallView:BCMassageLoveWallView!
	private var lostView:MassageLostListView!
	
	private var runkeeperSwitch = DGRunkeeperSwitch()
	
	// 隐藏View
	private var actionListView:MassageMoreActionView!
	private var actionListViewBackView:UIView!
	private var leaveContectInfoView:BCLeaveContectInfoView!
	private var leaveContectInfoViewBackView:UIView!
	
	// 状态和数据
	private var isShowingActionView = false
	private var isShowingleaveContectInfoView = false
	private var playgroundPage = 0
	private var loveWallListPage = 0
	private var isScrollTriggedByScrollView = false
	
	private var lostAndFindList = [BCLostAndFoundModel]()
	private var loveWallModels = [EECommunityLoveWallModel]()
	private var choosedIndex = 0
	private var currentShowingPage = 0
	
	//MARK:- 生命周期
	override func viewDidLoad() {
		super.viewDidLoad()
		initScrollView()
		initNavBar()
		loveWallView.startLoadingAnimation()
		lostView.startLoadingAnimation()
		showNavRightButtonWithIcon("navbar_add")
	}
	
	override func onRightNavButtonPress() {
		self.showOrHideActionList()
	}
	
	override func onTintColorChanged() {
		super.onTintColorChanged()
		lostView.changeTintColor(nil)
		self.scrollView.backgroundColor =  Color.getGradientColor()
	}
	
	//MARK:- 网络请求
	private func getDateFromServer() {
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
				self.lostView.endLoadMoreRefreshing(true)
			}, onNetErrorBlock: {() -> Void in
				self.lostView.endLoadMoreRefreshing(true)
				Hud.showMassage(NetErrorWarning)
		})
	}
	
	private func getLoveWallDataRequest() {
		EECommunityLoveWallModel.getModelsFromNetWorkForPage(loveWallListPage) { (error, models) -> () in
			if let models = models {
				self.loveWallModels.appendContentsOf(models)
				self.loveWallView.iniModelList(self.loveWallModels)
				if models.count == 0 {
					self.loveWallView.endLoadMoreRefreshing(false)
				} else {
					self.loveWallView.endLoadMoreRefreshing(true)
				}
			} else {
				Hud.showError(error)
			}
		}
	}
	
	private func sendMassageToLoster(phone:String,info:String) {
		Hud.showLoading("正在发送")
		
		let url = getComURL("api/lostFound/sendMessage")
		
		let params:[String:AnyObject] = [
			"id":self.lostAndFindList[choosedIndex].id,
			"phone":phone,
			"message":info
		]
		
		BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params,
			onFinishedBlock: { (response) -> Void in
				Hud.showMassage("发送成功")
				self.leaveContectInfoView.clearText()
				if self.isShowingleaveContectInfoView {
					self.showOrHideLeaveContectInfoView()
				}
			}, onFailedBlock: { (reason) -> Void in
				Hud.showError(reason)
			}) { () -> Void in
				Hud.showMassage(NetErrorWarning)
		}
	}
	
	//MARK:- 动画
	@objc private func showOrHideActionList() {
		if !isShowingActionView {
			isShowingActionView = true
			
			actionListViewBackView = UIView()
			actionListViewBackView.backgroundColor = UIColor.clearColor()
			self.view.addSubview(actionListViewBackView)
			
			actionListViewBackView.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(self.view)
			}
			
			actionListViewBackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showOrHideActionList"))
			
			actionListView = MassageMoreActionView(forStyle: currentShowingPage)
			actionListView.delegate = self
			actionListView.alpha = 0
			self.view.addSubview(actionListView)
			actionListView.snp_makeConstraints(closure: { (make) -> Void in
				make.bottom.equalTo(self.navBar.snp_bottom)
				make.right.equalTo(self.view.snp_right).offset(-5)
				make.width.equalTo(120)
				make.height.equalTo(actionListView.height)
			})
			self.view.bringSubviewToFront(navBar)
			self.view.layoutIfNeeded()
			
			UIView.animateWithDuration(0.3, animations: { () -> Void in
				self.actionListView.snp_updateConstraints(closure: { (make) -> Void in
					make.bottom.equalTo(self.navBar.snp_bottom).offset(self.actionListView.height+5)
				})
				self.actionListView.alpha = 1
				self.view.layoutIfNeeded()
			})
		} else {
			isShowingActionView = false
			UIView.animateWithDuration(0.3, animations: { () -> Void in
				self.actionListView.snp_updateConstraints(closure: { (make) -> Void in
					make.bottom.equalTo(self.navBar.snp_bottom)
				})
				self.actionListView.alpha = 1
				self.view.layoutIfNeeded()
				}, completion: { (finished) -> Void in
					self.actionListView.removeFromSuperview()
					self.actionListViewBackView.removeFromSuperview()
			})
		}
	}
	
	@objc private func showOrHideLeaveContectInfoView() {
		if !isShowingleaveContectInfoView {
			isShowingleaveContectInfoView = true
			leaveContectInfoViewBackView = UIView()
			leaveContectInfoViewBackView.backgroundColor = UIColor.blackColor()
			leaveContectInfoViewBackView.alpha = 0
			self.view.addSubview(leaveContectInfoViewBackView)
			
			let tapGasture = UITapGestureRecognizer(target: self, action: "showOrHideLeaveContectInfoView")
			leaveContectInfoViewBackView.addGestureRecognizer(tapGasture)
			
			leaveContectInfoViewBackView.snp_makeConstraints(closure: { (make) -> Void in
				make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0))
			})
			
			leaveContectInfoView = BCLeaveContectInfoView()
			leaveContectInfoView.delegate = self
			self.view.addSubview(leaveContectInfoView)
			leaveContectInfoView.snp_makeConstraints(closure: { (make) -> Void in
				make.width.equalTo(ScreenWidth-20)
				make.height.equalTo(180)
				make.center.equalTo(self.view.snp_center)
			})
			
			leaveContectInfoView.transform = CGAffineTransformMakeScale(0.01, 0.01)
			self.view.layoutIfNeeded()
			
			UIView.animateWithDuration(0.3, animations: { () -> Void in
				self.leaveContectInfoView.transform = CGAffineTransformMakeScale(1, 1)
				self.leaveContectInfoViewBackView.alpha = 0.3
			})
		} else {
			isShowingleaveContectInfoView = false
			UIView.animateWithDuration(0.3, animations: { () -> Void in
				self.leaveContectInfoView.transform = CGAffineTransformMakeScale(0.01, 0.01)
				self.leaveContectInfoViewBackView.alpha = 0
				}, completion: { (finished) -> Void in
					self.leaveContectInfoView.removeFromSuperview()
					self.leaveContectInfoViewBackView.removeFromSuperview()
			})
		}
	}
	
	@objc private func runkeeperSwitchValueChanged() {
		if !isScrollTriggedByScrollView {
			let index = runkeeperSwitch.selectedIndex
			self.scrollView.setContentOffset(CGPointMake(ScreenWidth*CGFloat(index), 0), animated: true)
			self.currentShowingPage = index
		} else {
			isScrollTriggedByScrollView = false
		}
		
	}
	
	
	//MARK:- 初始化UI
	func initScrollView() {
		self.scrollView.pagingEnabled = true
		self.scrollView.showsHorizontalScrollIndicator = false
		self.scrollView.contentSize = CGSizeMake(ScreenWidth * 2, scrollView.frame.size.height);
		self.scrollView.delegate = self
		
		self.scrollView.backgroundColor =  Color.getGradientColor()
		
		lostView = MassageLostListView()
		self.scrollView.addSubview(lostView)
		lostView.delegate = self
		
		lostView.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(self.scrollView.snp_top)
			make.left.equalTo(self.scrollView.snp_left)
			make.width.equalTo(self.scrollView.snp_width)
			make.height.equalTo(self.scrollView.snp_height)
		})
		
		loveWallView = BCMassageLoveWallView()
		self.scrollView.addSubview(loveWallView)
		loveWallView.delegate = self
		
		loveWallView.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(self.scrollView.snp_top)
			make.left.equalTo(self.scrollView.snp_left).offset(ScreenWidth)
			make.width.equalTo(self.scrollView.snp_width)
			make.height.equalTo(self.scrollView.snp_height)
		})
	}
	
	func initNavBar() {
		runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "失物招领", rightTitle: "表白墙")
		runkeeperSwitch.layer.cornerRadius = 26/2
		runkeeperSwitch.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.298731161347518)
		runkeeperSwitch.selectedBackgroundColor = .whiteColor()
		runkeeperSwitch.titleColor = .whiteColor()
		runkeeperSwitch.selectedTitleColor = Color.primaryTintColor
		runkeeperSwitch.titleFont = UIFont.systemFontOfSize(13)
		runkeeperSwitch.addTarget(self, action: "runkeeperSwitchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
		self.navBar.addSubview(runkeeperSwitch)
		self.navBar.titleLabel.hidden = true
		
		runkeeperSwitch.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(160)
			make.height.equalTo(26)
			make.centerY.equalTo(self.navBar.titleLabel.snp_centerY)
			make.centerX.equalTo(self.navBar.snp_centerX)
		}
	}
}

//MARK:- UIAlertViewDelegate
extension CommunityViewController:UIAlertViewDelegate {
	func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		print(buttonIndex)
		if buttonIndex == 0 {
			let vc = CommunitySendFindMassageToLosterViewController()
			self.pushToViewController(vc)
		} else {
			let vc = CommunitySendMassageToPublicController()
			self.pushToViewController(vc)
		}
	}
}


//MARK:- 动作列表ViewDelegate
extension CommunityViewController:MassageMoreActionViewDelegate {
	func didSelectAtIndex(index:Int) {
		runAfterLoginToCommunity { () -> () in
			if self.currentShowingPage == 0 {
				switch index {
				case 0:
					let vc = CommunitySendMassageToPublicController()
					vc.isLost = true
					self.pushToViewController(vc)
				case 1:
					let alertView = UIAlertView()
					alertView.title = "请选择发布渠道"
					alertView.message = "若手中有失主的学号信息，请选择直接发送消息至失主，提高找回概率。若没有失主此信息，则选择发不到广场等待认领。"
					alertView.addButtonWithTitle("直接发送")
					alertView.addButtonWithTitle("发布广场")
					alertView.tag = 1
					alertView.delegate = self
					alertView.show()
				case 2:
					let vc = EEMyPublishedListController(nib: "EEMyPublishedListController")
					self.pushToViewController(vc)
				default:
					break
				}
			} else {
				switch index {
				case 0:
					let vc = EESendLoveWallController()
					self.pushToViewController(vc)
				case 1:
					let vc = EEMyLoveWallListController(nib: "EEMyLoveWallListController")
					self.pushToViewController(vc)
				default:
					break
				}
			}
		}
		self.showOrHideActionList()
	}
}

//MARK:- LeaveContectInfoViewDelegate
extension CommunityViewController:BCLeaveContectInfoViewDelegate {
	func onSendButtonPressed(phoneNumber: String, contactInfo: String) {
		sendMassageToLoster(phoneNumber, info: contactInfo)
	}
}


//MARK:- MassageLoveWallViewDelegate
extension CommunityViewController:BCMassageLoveWallViewDelegate {
	func LoveWallViewRefresh() {
		self.loveWallModels.removeAll()
		loveWallListPage = 0
		getLoveWallDataRequest()
	}
	
	func LoveWallViewLoadMore() {
		loveWallListPage += 1
		getLoveWallDataRequest()
	}
	
	func LoveWallViewSelectedAtCell(index: Int) {
		runAfterLoginToCommunity { () -> () in
			let vc = BCLoveWallDetailViewController(nibName:"BCLoveWallDetailViewController",bundle:nil)
			vc.model = self.loveWallModels[index]
			self.pushToViewController(vc)
		}
	}
	func LoveWallViewLikeButtonPressed(index:Int) {
		self.loveWallModels[index].favorite = !self.loveWallModels[index].favorite
		self.loveWallModels[index].favoriteCount += 1
		self.loveWallView.iniModelList(self.loveWallModels)
		//    self.likeLoveWallRequest(index)
	}
	
	func LoveWallViewCommmentButtonPress(index:Int) {
		
	}
}

//MARK:- MassageLostListViewDelegate
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
		runAfterLoginToCommunity { () -> () in
			self.choosedIndex = index
			//TODO: 联系我
			self.showOrHideLeaveContectInfoView()
		}
	}
	
	func MassageLostListImagesPressed(imageLinks: [String],index:Int) {
		let vc = EEBaseImagesListController(style: .Link)
		vc.page = index
		vc.imageLinks = imageLinks
		self.pushToViewController(vc)
	}
}

//MARK:- UIScrollViewDelegate
extension CommunityViewController:UIScrollViewDelegate {
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		self.currentShowingPage = Int((scrollView.contentOffset.x)/ScreenWidth)
		let page = Int((scrollView.contentOffset.x+ScreenWidth/2)/ScreenWidth)
		isScrollTriggedByScrollView = true
		runkeeperSwitch.setSelectedIndex(page, animated: true)
	}
}
