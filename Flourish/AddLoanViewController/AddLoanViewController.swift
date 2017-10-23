//
//  AddLoanViewController.swift
//  Flourish
//
//  Created by Jason Du on 10/21/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation
import UIKit

struct AddLoanData {
    var date: String
    var locked: Bool
}

struct DataSend {
    var purpose: String?
    var loanAmount: String?
    var selectedIndex: Int?
    var tableArr: [AddLoanData]?
}

class AddLoanViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!

    // Schedule
    @IBOutlet weak var purposeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var startingDateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loanAmountTextField: SkyFloatingLabelTextField!

    // Pickers
    let datePicker = UIDatePicker()
    let billingPicker = UIPickerView()
    let loanAmountPicker = UIPickerView()
    let loanDataArr = ["$250.00", "$500.00", "$750.00", "$1000.00"]

    var tableArr: [AddLoanData] = []

    @IBOutlet weak var interestSwitch: UISwitch!
    @IBOutlet weak var searchButton: UIButton!

    @IBOutlet weak var tableView: UITableView!

    var selectInt: Int = 0

    override func viewDidLoad() {
        formatNavBar()
        formatCardView()
        formatTextFields()
        formatPicker()
        searchButton.layer.cornerRadius = 10
    }

    @IBAction func searchPressed(_ sender: Any) {
        let date = datePicker.date
        let date1End = Calendar.current.date(byAdding: .day, value: 7, to: date)
        let date1Data = "\(formatDate(date: date)) - \(formatDate(date: date1End!))"

        let date2Begin = Calendar.current.date(byAdding: .day, value: 1, to: date1End!)
        let date2End = Calendar.current.date(byAdding: .day, value: 7, to: date2Begin!)
        let date2Data = "\(formatDate(date: date2Begin!)) - \(formatDate(date: date2End!))"

        let date3Begin = Calendar.current.date(byAdding: .day, value: 1, to: date2End!)
        let date3End = Calendar.current.date(byAdding: .day, value: 7, to: date3Begin!)
        let date3Data = "\(formatDate(date: date3Begin!)) - \(formatDate(date: date3End!))"

        let date4Begin = Calendar.current.date(byAdding: .day, value: 1, to: date3End!)
        let date4End = Calendar.current.date(byAdding: .day, value: 7, to: date4Begin!)
        let date4Data = "\(formatDate(date: date4Begin!)) - \(formatDate(date: date4End!))"

        let date5Begin = Calendar.current.date(byAdding: .day, value: 1, to: date4End!)
        let date5End = Calendar.current.date(byAdding: .day, value: 7, to: date5Begin!)
        let date5Data = "\(formatDate(date: date5Begin!)) - \(formatDate(date: date5End!))"

        tableArr.append(AddLoanData(date: date1Data, locked: true))
        tableArr.append(AddLoanData(date: date2Data, locked: true))
        tableArr.append(AddLoanData(date: date3Data, locked: false))
        tableArr.append(AddLoanData(date: date4Data, locked: false))
        tableArr.append(AddLoanData(date: date5Data, locked: false))
        UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
        searchButton.isUserInteractionEnabled = false

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddLoanConfirmationViewController" {
            let controller = segue.destination as! AddLoanConfirmationViewController
            controller.data = DataSend(purpose: purposeTextField.text, loanAmount: loanAmountTextField.text, selectedIndex: selectInt, tableArr: tableArr)
        }
    }

    func sendToConfirmationVC(selectedInt: Int) {
        selectInt = selectedInt
        performSegue(withIdentifier: "toAddLoanConfirmationViewController", sender: self)
    }

}

// Formatting
extension AddLoanViewController {

    func formatNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(GradientNavBar.create(size: self.navigationController!.navigationBar.bounds), for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let systemBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNavBar))
        navigationItem.rightBarButtonItem = systemBarButtonItem
    }

    func formatCardView() {
        cardView.layer.shadowRadius = 2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowOpacity = 0.2
    }

    func formatTextFields() {
        formatTextField(textField: purposeTextField)
        formatTextField(textField: loanAmountTextField)
        formatTextField(textField: startingDateTextField)
    }

    func formatTextField(textField: SkyFloatingLabelTextField) {
        textField.delegate = self
        textField.selectedLineColor = Theme.darkBlue
        textField.selectedTitleColor = Theme.darkBlue
    }
}

// Helpers
extension AddLoanViewController {
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: date)
    }
}

// Actions
extension AddLoanViewController {

    @objc func cancelNavBar() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func cancel() {
        self.view.endEditing(true)
    }

    @objc func loanAmountPickerDonePressed() {
        loanAmountTextField.text = loanDataArr[loanAmountPicker.selectedRow(inComponent: 0)]
        self.view.endEditing(true)
    }

    @objc func dateTextFieldDonePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: datePicker.date)
        startingDateTextField.text = dateString
        self.view.endEditing(true)
    }
}

extension AddLoanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableArr.count == 0 {
            return 0
        } else {
            return tableArr.count + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLoanHeaderCell") as! AddLoanHeaderCell
            return cell
        } else {
            if tableArr[indexPath.row - 1].locked {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddLoanDisabledCell") as! AddLoanDisabledCell
                cell.dateLabel.text = tableArr[indexPath.row - 1].date
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddLoanCell") as! AddLoanCell
                cell.dateLabel.text = tableArr[indexPath.row - 1].date
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 60.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {

        } else {
            if tableArr[indexPath.row - 1].locked {
            } else {
                sendToConfirmationVC(selectedInt: indexPath.row - 1)
            }
        }
    }
}

// Textfield Delegate
extension AddLoanViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// Picker Delegate
extension AddLoanViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return loanDataArr.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return loanDataArr[row]
    }
}

// Textview formatting
extension AddLoanViewController {

    func formatPicker() {
        formatDatePicker()
        formatLoanAmountPickerView()
    }

    func formatDatePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateTextFieldDonePressed))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let flexibleSpacing = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([cancelItem, flexibleSpacing, doneItem], animated: false)
        startingDateTextField.inputAccessoryView = toolBar
        startingDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }

    func formatLoanAmountPickerView() {
        loanAmountPicker.delegate = self
        loanAmountPicker.dataSource = self
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(loanAmountPickerDonePressed))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let flexibleSpacing = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([cancelItem, flexibleSpacing, doneItem], animated: false)
        loanAmountTextField.inputAccessoryView = toolBar
        loanAmountTextField.inputView = loanAmountPicker
    }
}

