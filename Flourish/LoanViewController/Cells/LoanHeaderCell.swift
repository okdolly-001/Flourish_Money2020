//
//  LoanHeaderCell.swift
//  Flourish
//
//  Created by Jason Du on 10/21/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation
import UIKit

class LoanHeaderCell: UITableViewCell {

    @IBOutlet weak var gradientView: EZYGradientView!

    override func layoutSubviews() {
        gradientView.firstColor = Theme.lightBlue
        gradientView.secondColor = Theme.darkBlue
        gradientView.angleº = 70
        gradientView.fadeIntensity = 1
        gradientView.colorRatio = 0.5
    }
}
