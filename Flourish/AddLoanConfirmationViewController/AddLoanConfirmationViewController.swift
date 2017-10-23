//
//  AddLoanConfirmationViewController.swift
//  Flourish
//
//  Created by Jason Du on 10/21/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation
import UIKit

class AddLoanConfirmationViewController: UIViewController {

    var data: DataSend?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        let systemBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneNavBar))
        navigationItem.rightBarButtonItem = systemBarButtonItem
    }

    @objc func doneNavBar() {
        Network.createLoan { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddLoanConfirmationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableArr = data?.tableArr {
            return tableArr.count + 1
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = data, let tableArr = data.tableArr {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddLoanConfirmationHeaderCell") as! AddLoanConfirmationHeaderCell
                cell.purposeLabel.text = data.purpose!
                cell.dateLabel.text = "Oct 23 - Nov 31"
                cell.paymentLabel.text = data.loanAmount!
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddLoanConfirmationCell") as! AddLoanConfirmationCell

                if indexPath.row == 3 {
                    cell.amountLabel.text = "+ $200.00"
                    cell.amountLabel.textColor = Theme.green
                } else {
                    cell.amountLabel.text = "- $50.00"
                    cell.amountLabel.textColor = Theme.red
                }

                cell.dateLabel.text = tableArr[indexPath.row - 1].date
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = data?.tableArr {
            if indexPath.row == 0 {
                return 220.0
            } else {
                return 60.0
            }
        } else {
            return 0.0
        }
    }
}
