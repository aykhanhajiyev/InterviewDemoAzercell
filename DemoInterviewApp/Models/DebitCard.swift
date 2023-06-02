//
//  DebitCard.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 31.05.23.
//

import Foundation

struct DebitCard {
    let cardNumber: String
    var balance: Double
    
    init(cardNumber: String, balance: Double = 10) {
        self.cardNumber = cardNumber
        self.balance = balance
    }
}
