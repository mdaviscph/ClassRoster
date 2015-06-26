//
//  TableViewCell.swift
//  ClassRoster
//
//  Created by mike davis on 6/23/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

  @IBOutlet private weak var firstNameLabel: UILabel!
  @IBOutlet private weak var lastNameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(false, animated: animated)
  }
  
  func setDisplay(first: String, last: String, image: UIImage?) {
    firstNameLabel.text = first
    lastNameLabel.text = last
    if let image = image {
      profileImageView.image = image
      profileImageView.layer.cornerRadius = 25
      profileImageView.layer.masksToBounds = true
    }
    else {
      profileImageView.image = nil
    }
  }
}
