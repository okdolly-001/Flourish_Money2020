//
//  LoanDetailsHeaderCell.swift
//  Flourish
//
//  Created by Jason Du on 10/22/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation
import UIKit

class LoanDetailsHeaderCell: UITableViewCell {
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var netAmount: UILabel!
    @IBOutlet weak var payButton: UIButton!

    var slot: Slot?

    override func layoutSubviews() {
        if let slot = slot {
            circleView.layer.cornerRadius = circleView.frame.height / 2
            circleView.clipsToBounds = true
            payButton.layer.cornerRadius = payButton.frame.height / 2
            if let loanStatus = slot.loanStatus {
                if loanStatus == "COMPLETED" {
                    descriptionLabel.text = "Has contributed to help fund your loan."
                    payButton.isUserInteractionEnabled = false
                    payButton.backgroundColor = UIColor.white
                    payButton.layer.borderColor = Theme.darkBlue.cgColor
                    payButton.layer.borderWidth = 2
                    payButton.setTitle("Accepted", for: .normal)
                    payButton.setTitleColor(Theme.darkBlue, for: .normal)
                } else {
                    payButton.backgroundColor = Theme.darkBlue
                    payButton.setTitle("Accept", for: .normal)
                    payButton.setTitleColor(UIColor.white, for: .normal)
                }
            }
            if profilePicture.image == nil {
                profilePicture.image = UIImage(named: "girl\(Int(arc4random_uniform(10)) + 1)")
            }
            if name.text == "" {
                name.text = FakeNames.generateBoy()
            }

            if slot.netAmount > 0 {
                netAmount.text = "+ $\(slot.netAmount / 4).00"
                netAmount.textColor = Theme.green
            } else {
                netAmount.text = "- $\(slot.netAmount * -1).00"
                netAmount.textColor = Theme.red
            }
            date.text = slot.settledBy
        }
    }

}
