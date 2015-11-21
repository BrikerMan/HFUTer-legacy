//
//  BCSendLoveWallViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/10/24.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class BCSendLoveWallViewController: EEBaseViewController {
  
  @IBOutlet weak var button0: UIButton!
  @IBOutlet weak var button1: UIButton!
  @IBOutlet weak var button2: UIButton!
  @IBOutlet weak var button3: UIButton!
  @IBOutlet weak var button4: UIButton!
  @IBOutlet weak var button5: UIButton!
  @IBOutlet weak var button6: UIButton!
  @IBOutlet weak var contentLabel: BCTextField!
  @IBOutlet weak var unnamedSwitch: UISwitch!
  
  private var selectedColor = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fixUI()
    // Do any additional setup after loading the view.
  }
  
  func fixUI() {
    navTitle = "发表白墙"
    let buttonList = [button0,button1,button2,button3,button4,button5,button6]
    for i in 0..<buttonList.count {
      buttonList[i].backgroundColor = Color.getLoveWallColors(i)
      buttonList[i].layer.cornerRadius = buttonList[i].frame.size.height/2
    }
    self.view.layoutIfNeeded()
    self.navBar.view?.backgroundColor = Color.getLoveWallColors(0)
//    self.showNavBarRightButton("nav_send")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onColorChooseButtonPressed(sender: UIButton) {
    self.selectedColor = sender.tag
    self.navBar.view?.backgroundColor = Color.getLoveWallColors(sender.tag)
  }
  
//  override func navBarRightButtonPressed() {
//    sendLoveWall()
//  }

  func sendLoveWall() {
    if contentLabel.text?.characters.count < 5 {
      Hud.showMassage("请输入5个字以上")
      return
    }
    let url = "http://hfut.cn-hangzhou.aliapp.com/api/confession/createConfession"
    let params = [
      "content":contentLabel.text!,
      "anonymous":unnamedSwitch.on,
      "color":self.selectedColor
    ]
    
    BCBaseRequest.getJsonFromCommunityServerRequest(url, params: params as! [String : AnyObject],
      onFinishedBlock: { (response) -> Void in
        Hud.showMassage("发送成功")
        self.pop()
      }, onFailedBlock: { (reason) -> Void in
        Hud.showError(reason)
      }) { () -> Void in
        Hud.showError("网络错误，请稍候尝试")
    }
  }
}
