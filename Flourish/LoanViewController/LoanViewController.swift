//
//  LoanViewController.swift
//  Flourish
//
//  Created by Jason Du on 10/21/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation
import UIKit

class LoanViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var loanData: LoanData?
    var selectedLoan: Loan?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } 
    }

    override func viewWillAppear(_ animated: Bool) {
        Network.getData(success: { (model: Any?) in
            if let loanData = model as? LoanData {
                self.loanData = loanData
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLoanDetailViewController" {
            let controller = segue.destination as! LoanDetailViewController
            controller.data = selectedLoan

        }
    }

    func sendToLoanDetailViewController(loan: Loan) {
        selectedLoan = loan
        performSegue(withIdentifier: "toLoanDetailViewController", sender: self)
    }
}

extension LoanViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let loanData = loanData {
            return loanData.activeLoan.count + loanData.completedLoan.count + 2
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let loanData = loanData {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoanDashBoardCell") as! LoanDashBoardCell
                cell.delegate = self
                return cell
            } else if indexPath.row <= loanData.activeLoan.count  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoanInProgressCell") as! LoanInProgressCell
                cell.loan = loanData.activeLoan[indexPath.row - 1]
                return cell
            } else if indexPath.row == loanData.activeLoan.count + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoanHeaderCell") as! LoanHeaderCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoanCompleteCell") as! LoanCompleteCell
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let loanData = loanData {
            if indexPath.row == 0 {
                return 220.0
            } else if indexPath.row <= loanData.activeLoan.count  {
                return 250.0
            } else if indexPath.row == loanData.activeLoan.count + 1 {
                return 45.0
            } else {
                return 100.0
            }
        } else {
            return 0.0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let loanData = loanData {
            if indexPath.row == 0 {

            } else if indexPath.row <= loanData.activeLoan.count  {
                sendToLoanDetailViewController(loan: loanData.activeLoan[indexPath.row - 1])
            }
        }
    }
}

extension LoanViewController: loanCellDelegate {
    func addLoan() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddLoanViewController")
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        self.present(navigationController, animated: true, completion: nil)
    }
}

extension UINavigationController
{
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

