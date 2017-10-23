//
//  LoanDetailViewController.swift
//  Flourish
//
//  Created by Jason Du on 10/21/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation
import UIKit

class LoanDetailViewController: UIViewController {

    var data: Loan?
    
    @IBOutlet weak var tableView: UITableView!

    var paymentIndex = 0
    var offset = 0

    override func viewDidLoad() {
        let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        tableView.animateViews(animations: [fromAnimation, zoomAnimation], duration: 0.5)


        if let data = data {
            var index = 0
            for slot in data.slots {
                if isPayment(slot: slot) {
                    paymentIndex = index
                    if isComplete(slot: slot) {
                        offset = 3
                    } else {
                        offset = 0
                    }
                }
                if slot.netAmount > 0 {
                    paymentIndex = index
                    if let status = slot.loanStatus {
                        if status == "COMPLETED" {
                            offset = 3
                        } else {
                            offset = 0
                        }
                    }
                }
                index += 1
            }
            self.title = data.purpose
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(GradientNavBar.create(size: self.navigationController!.navigationBar.bounds), for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
    }

    func isComplete(slot: Slot?) -> Bool {
        if let slot = slot {
            if let status = slot.loanStatus {
                if status == "COMPLETED" {
                    return true
                } else if let _ = slot.settlementHash {
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

extension LoanDetailViewController: UITableViewDelegate, UITableViewDataSource {
    // 8 rows 0 - 7
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if let data = data {
            for slot in data.slots {
                if !isPayment(slot: slot) {
                    rowCount += 1
                } else if isComplete(slot: slot) {
                    rowCount += 4
                } else {
                    rowCount += 1
                }
            }
        }
        print("ROW COUNT: \(rowCount)")
        return rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = data else { return UITableViewCell() }
        if indexPath.row < paymentIndex {
            if !isComplete(slot: data.slots[indexPath.row]) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoanDetailsUnscheduledCell") as! LoanDetailsUnscheduledCell
                cell.slot = data.slots[indexPath.row]
                cell.weekLabel.text = "Week \(indexPath.row + 1)"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoanDetailsHeaderCell") as! LoanDetailsHeaderCell
                cell.slot = data.slots[indexPath.row]
                return cell
            }
        } else if indexPath.row == paymentIndex {
                if isComplete(slot: data.slots[indexPath.row]) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "LoanDetailsHeaderCell") as! LoanDetailsHeaderCell
                    cell.slot = data.slots[indexPath.row]
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "LoanDetailsUnscheduledCell") as! LoanDetailsUnscheduledCell
                    cell.slot = data.slots[indexPath.row]
                    cell.weekLabel.text = "Week \(indexPath.row + 1)"
                    return cell
                }
        } else if indexPath.row <= paymentIndex + offset  {
                print("indexPath.row < paymentIndex + offset \(indexPath.row)")
                if isComplete(slot: data.slots[paymentIndex]) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "LoanDetailsCell") as! LoanDetailsCell
                    cell.slot = data.slots[paymentIndex]
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "LoanDetailsUnscheduledCell") as! LoanDetailsUnscheduledCell
                    cell.slot = data.slots[paymentIndex]
                    cell.weekLabel.text = "Week \(indexPath.row + 1)"
                    return cell
                }
        } else {
            if !isComplete(slot: data.slots[indexPath.row - offset]) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoanDetailsUnscheduledCell") as! LoanDetailsUnscheduledCell
                cell.slot = data.slots[indexPath.row - offset]
                cell.weekLabel.text = "Week \(indexPath.row - offset)"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoanDetailsHeaderCell") as! LoanDetailsHeaderCell
                cell.slot = data.slots[indexPath.row - offset]
                print("\(indexPath.row) - \(offset)")
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let data = data else { return 0.0 }
        if indexPath.row < paymentIndex {
            if !isComplete(slot: data.slots[indexPath.row]) {
                return 120.0
            } else {
                return 190.0
            }
        } else if indexPath.row < paymentIndex + offset && indexPath.row >= paymentIndex {

            if indexPath.row == paymentIndex {
                if isComplete(slot: data.slots[indexPath.row]) {
                    return 190.0
                } else {
                    return 120.0
                }
            } else {
                if isComplete(slot: data.slots[paymentIndex]) {
                    return 150.0
                } else {
                    return 120.0
                }
            }
        } else {
            if !isComplete(slot: data.slots[indexPath.row - offset]) {
                return 120.0
            } else {
                return 190.0
            }
        }
    }
}
