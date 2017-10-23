//
//  Network.swift
//  Flourish
//
//  Created by Jason Du on 10/21/17.
//  Copyright © 2017 Jason Du. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

public typealias SuccessBlock = (Any?) -> Void
public typealias FailureBlock = (Any?) -> Void

open class Network {
    static let base = "http://ec2-18-221-49-193.us-east-2.compute.amazonaws.com/graphql"
    static let header: HTTPHeaders = ["Content-Type": "application/graphql"]

    open class func getData(success: @escaping SuccessBlock) {
        let parameters: Parameters = ["query": "{ me(userId: \"137\") { firstName lastName trust activeLoans { amount slots { netAmount loanStatus settleReason settleBy settledOn settledWith settlementHash } startDate purpose } pastLoans { amount slots { netAmount loanStatus settleReason settleBy settledOn settledWith settlementHash } startDate purpose } } }"]

        Alamofire.request(base, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            let json = JSON(response.data)
            print(json)

            if let data = json["data"].dictionary {
                if let me = data["me"] {
                    guard let firstName = me["firstName"].string else { return }
                    guard let lastName = me["lastName"].string else { return }
                    guard let trust = me["trust"].int else { return }
                    var activeLoanArr: [Loan] = []
                    if let activeLoans = me["activeLoans"].array {
                        for loan in activeLoans {
                            guard let amount = loan["amount"].int else { return }
                            guard let purpose = loan["purpose"].string else { return }
                            guard let startDate = loan["startDate"].string else { return }

                            var slotsArr: [Slot] = []

                            if let slots = loan["slots"].array {
                                for slot in slots {

                                    var settledBy: String? = nil
                                    var settledOn: String? = nil
                                    var loanStatus: String? = nil
                                    var settlementHash: String? = nil
                                    var settleReason: String? = nil
                                    var settledWith: [String] = []

                                    if let testSettleBy = slot["settleBy"].string {
                                        settledBy = testSettleBy
                                    }

                                    if let testSettledOn = slot["settledOn"].string {
                                        settledOn = testSettledOn
                                    }

                                    if let testLoanStatus = slot["loanStatus"].string {
                                        loanStatus = testLoanStatus
                                    }

                                    if let testSettlementHash = slot["settlementHash"].string {
                                        settlementHash = testSettlementHash
                                    }

                                    if let testSettleReason = slot["settleReason"].string {
                                        settleReason = testSettleReason
                                    }

                                    guard let netAmount = slot["netAmount"].int else { return }

                                    if let testSettledWith = slot["settledWith"].array {
                                        for person in testSettledWith {
                                            if let strPerson = person.string {
                                                settledWith.append(strPerson)
                                            }
                                        }
                                    }

                                    slotsArr.append(Slot(settledBy: settledBy, settledOn: settledOn, loanStatus: loanStatus, settlementHash: settlementHash, settleReason: settleReason, settledWith: settledWith, netAmount: netAmount))

                                }
                            }
                            let loan = Loan(amount: amount, purpose: purpose, startDate: startDate, slots: slotsArr)
                            activeLoanArr.append(loan)
                        }
                        success(LoanData(firstName: firstName, lastName: lastName, trust: trust, activeLoan: activeLoanArr, completedLoan: ["","","","",""]))
                    }
                }
            }
        }
    }

    open class func createLoan(success: @escaping SuccessBlock) {
        let parameters: Parameters = ["query": "{ createLoan }"]

        Alamofire.request(base, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            success(response)
        }
    }

    open class func initiateSettlement(success: @escaping SuccessBlock) {
        let parameters: Parameters = ["query": "{ initiateSettlement(settlementHash:\"66dd370f626c5fda7c8f1680c6c1f100d9a495b6768dfef9d0466506e24a16e9\")}"]
        Alamofire.request(base, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            success(response)
        }
    }

}
