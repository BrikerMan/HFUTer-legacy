//
//  InfoBookListViewController.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/1.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit

class InfoBookListViewController: EEBaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
getBooksListRequest()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func getBooksListRequest() {
    let operation = InfoGetBooksListRequest()
    operation.get({ () -> () in
      
      }, onFailedBlock: { (error) -> () in
        
      }) { () -> () in
        
    }
  }
  
}
