//
//  LoanInProgressCell.swift
//  Flourish
//
//  Created by Jason Du on 10/21/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation
import UIKit

class LoanInProgressCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!

    // Data
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var loanAmountHeaderLabel: UILabel!
    @IBOutlet weak var loanAmountLabel: UILabel!
    @IBOutlet weak var billingAmountLabel: UILabel!
    @IBOutlet weak var billingPeriodLabel: UILabel!

    // Circle
    @IBOutlet weak var circle1: UIView!
    @IBOutlet weak var circle2: UIView!
    @IBOutlet weak var circle3: UIView!
    @IBOutlet weak var circle4: UIView!
    @IBOutlet weak var circle5: UIView!

    var loan: Loan?

    override func layoutSubviews() {
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowRadius = 2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowOpacity = 0.2

        circle1.layer.cornerRadius = circle1.frame.width / 2
        circle2.layer.cornerRadius = circle2.frame.width / 2
        circle3.layer.cornerRadius = circle3.frame.width / 2
        circle4.layer.cornerRadius = circle4.frame.width / 2
        circle5.layer.cornerRadius = circle5.frame.width / 2

        if let loan = loan {
            nameLabel.text = loan.purpose
            loanAmountLabel.text = "$\(loan.amount).00"
            configureView(view: circle1, loanStatus: loan.slots[0].loanStatus, netAmount: loan.slots[0].netAmount)
            configureView(view: circle2, loanStatus: loan.slots[1].loanStatus, netAmount: loan.slots[1].netAmount)
            configureView(view: circle3, loanStatus: loan.slots[2].loanStatus, netAmount: loan.slots[2].netAmount)
            configureView(view: circle4, loanStatus: loan.slots[3].loanStatus, netAmount: loan.slots[3].netAmount)
            configureView(view: circle5, loanStatus: loan.slots[4].loanStatus, netAmount: loan.slots[4].netAmount)

        }
    }

    func configureView(view: UIView, loanStatus: String?, netAmount: Int) {
        if let loanStatus = loanStatus {
            if loanStatus == "COMPLETED" {
                view.backgroundColor = UIColor.lightGray
            } else if netAmount < 0 {
                view.backgroundColor = Theme.red
            } else {
                view.backgroundColor = Theme.green
            }
        } else {
            view.backgroundColor = UIColor.lightGray
        }
    }
}

