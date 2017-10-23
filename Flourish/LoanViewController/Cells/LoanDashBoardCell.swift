//
//  LoanHeaderCell.swift
//  Flourish
//
//  Created by Jason Du on 10/21/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation
import UIKit

class LoanDashBoardCell: UITableViewCell {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var gradientView: EZYGradientView!
    weak var delegate: loanCellDelegate?

    override func layoutSubviews() {
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.backgroundColor = Theme.darkBlue
        
        gradientView.firstColor = Theme.lightBlue
        gradientView.secondColor = Theme.darkBlue
        gradientView.angleº = 70
        gradientView.fadeIntensity = 1
        gradientView.colorRatio = 0.5

    }

    @IBAction func addButtonPressed(_ sender: Any) {
        delegate?.addLoan()
    }
}

protocol loanCellDelegate: class {
    func addLoan()
}
