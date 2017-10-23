//
//  LoanData.swift
//  Flourish
//
//  Created by Jason Du on 10/22/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation

struct LoanData {
    var firstName: String
    var lastName: String
    var trust: Int
    var activeLoan: [Loan]
    var completedLoan: [String]
}

struct Loan {
    var amount: Int
    var purpose: String
    var startDate: String
    var slots: [Slot]
}

struct Slot {
    var settledBy: String?
    var settledOn: String?
    var loanStatus: String?
    var settlementHash: String?
    var settleReason: String?
    var settledWith: [String]
    var netAmount: Int
}
