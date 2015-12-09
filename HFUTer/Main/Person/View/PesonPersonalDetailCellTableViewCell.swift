//
//  PesonPersonalDetailCellTableViewCell.swift
//  HFUTer
//
//  Created by Eliyar Eziz on 15/12/8.
//  Copyright © 2015年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

public class PesonPersonalDetailCellTableViewCell: Cell<String>,CellType {
  @IBOutlet weak var avatarImage: EEImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  
  public override func setup() {
    height = { 70 }
    row.title = nil
    super.setup()
    selectionStyle = .None
    avatarImage.layer.cornerRadius = 25
    accessoryType = .DisclosureIndicator
  }
  
  public override func update() {
    super.update()
    if DataEnv.eduUser.isLogin {
      let eduUser = DataEnv.eduUser
      nameLabel.text = eduUser.name
      detailLabel.text = "\(eduUser.academy) - \(eduUser.className)"
    }
    if DataEnv.comUser.isLogin {
      avatarImage.image = DataEnv.comUser.avatarImage
    }
  }
}

public final class PesonPersonalDetailCellTableViewRow: Row<String, PesonPersonalDetailCellTableViewCell>, RowType {
  required public init(tag: String?) {
    super.init(tag: tag)
    displayValueFor = nil
    cellProvider = CellProvider<PesonPersonalDetailCellTableViewCell>(nibName: "PesonPersonalDetailCellTableViewCell")
  }
  
  
}