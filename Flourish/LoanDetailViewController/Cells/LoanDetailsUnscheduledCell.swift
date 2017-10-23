//
//  LoanDetailsUnscheduledCell.swift
//  Flourish
//
//  Created by Jason Du on 10/22/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation
import UIKit

class LoanDetailsUnscheduledCell: UITableViewCell {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var netAmount: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var slot: Slot?

    override func layoutSubviews() {
        if let slot = slot {
            circleView.clipsToBounds = true
            if slot.netAmount > 0 {
                netAmount.text = "+ $\(slot.netAmount).00"
                netAmount.textColor = Theme.green
                circleView.layer.cornerRadius = circleView.frame.height / 2
                 circleView.backgroundColor = Theme.green
                descriptionLabel.text = "This payment has not been scheduled yet."
            } else {
                netAmount.textColor = Theme.red
                netAmount.text = "- $\(slot.netAmount * -1).00"
                circleView.layer.cornerRadius = circleView.frame.height / 2
                circleView.backgroundColor = Theme.red
                descriptionLabel.text = "This request has not been scheduled yet."
            }
            dateLabel.text = slot.settledBy
        }
    }

    func isComplete(slot: Slot?) -> Bool {
        if let slot = slot {
            if let status = slot.loanStatus {
                if status == "COMPLETED" {
                    return true
                }
            }
        }
        return false
    }

    func isPayment(slot: Slot?) -> Bool {
        if let slot = slot {
            if slot.netAmount > 0 {
                return true
            }
        }
        return false
    }
}
