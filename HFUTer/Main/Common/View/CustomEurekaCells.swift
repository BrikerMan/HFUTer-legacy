//
//  CustomEurekaCells.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/11/26.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Eureka

public final class CustomPushRow<T: Equatable> : SelectorRow<T, SelectorViewController<T>>, RowType {
  public required init(tag: String?) {
    super.init(tag: tag)
    presentationMode = .Show(controllerProvider: ControllerProvider.Callback {
      return SelectorViewController<T>(){ _ in }
      }, completionCallback: { vc in
        vc.navigationController?.popViewControllerAnimated(true)
    })
  }
}