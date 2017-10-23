//
//  LoanDetailsCell.swift
//  Flourish
//
//  Created by Jason Du on 10/22/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation
import UIKit

class LoanDetailsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var payAmountLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!

    var slot: Slot?

    override func layoutSubviews() {
        if let slot = slot {
            acceptButton.layer.cornerRadius = acceptButton.frame.height / 2
            if let loanStatus = slot.loanStatus {
                if loanStatus == "COMPLETED" {
                    descriptionLabel.text = "Has contributed to help fund your loan."
                    acceptButton.isUserInteractionEnabled = false
                    acceptButton.backgroundColor = UIColor.white
                    acceptButton.layer.borderColor = Theme.darkBlue.cgColor
                    acceptButton.layer.borderWidth = 2
                    acceptButton.setTitle("Accepted", for: .normal)
                    acceptButton.setTitleColor(Theme.darkBlue, for: .normal)
                }
            }
            if profilePicture.image == nil {
                profilePicture.image = UIImage(named: "girl\(Int(arc4random_uniform(10)) + 1)")
            }
            if nameLabel.text == "" {
                nameLabel.text = FakeNames.generateGirl()
            }
            payAmountLabel.text = "+ $\(slot.netAmount / 4).00"
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
