//
//  AddLoanDisabledCell.swift
//  Flourish
//
//  Created by Jason Du on 10/21/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation
import UIKit

class AddLoanDisabledCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dateLabel: UILabel!

    override func layoutSubviews() {
        cardView.layer.cornerRadius = cardView.frame.height / 2
    }
}
