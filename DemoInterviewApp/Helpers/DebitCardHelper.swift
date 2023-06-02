//
//  DebitCardHelper.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 02.06.23.
//

import Foundation

class DebitCardHelper {
    
    static let shared = DebitCardHelper()
    
    var debitCards: [DebitCard] {
        get {
            return self.customer.debitCards.reversed()
        }
    }
    
    private var customer: Customer
    
    init() {
        customer = CustomerHelper.shared.getCustomer()
    }
    
    func addDebitCardToCustomer(_ debitCard: DebitCard) {
        var debitCards = customer.debitCards
        debitCards.append(debitCard)
        customer.debitCards = debitCards
    }
    
    func removeDebitCardFromCustomer(_ cardNumber: String) {
        var debitCards = customer.debitCards
        if let firstIndex = debitCards.firstIndex(where: {$0.cardNumber == cardNumber}) {
            debitCards.remove(at: firstIndex)
            customer.debitCards = debitCards
        }
    }
    
    func startTransaction(sender: DebitCard, receiverCardNumber: String, amount: Double) -> DebitCardTransactionResult {
        var sender = sender
        
        guard var receiver = findReceiverWithCardNumber(receiverCardNumber) else {
            return .receiverNotFounded
        }
        
        if amount <= sender.balance {
            sender.balance -= amount
            receiver.balance += amount
            updateList(sender, receiver)
            return .success
        } else {
            return .senderAmountInsufficient
        }
    }
    
    private func findReceiverWithCardNumber(_ cardNumber: String) -> DebitCard? {
        return customer.debitCards.first(where: {$0.cardNumber == cardNumber })
    }
    
    private func updateList(_ sender: DebitCard, _ receiver: DebitCard) {
        var debitCards = customer.debitCards
        if let firstIndexOfSender = debitCards.firstIndex(where: {$0.cardNumber == sender.cardNumber }) {
            debitCards[firstIndexOfSender].balance = sender.balance
        }
        if let firstIndexOfReceiver = debitCards.firstIndex(where: {$0.cardNumber == receiver.cardNumber}) {
            debitCards[firstIndexOfReceiver].balance = receiver.balance
        }
        customer.debitCards = debitCards
    }
}

enum DebitCardTransactionResult {
    case success
    case receiverNotFounded
    case senderAmountInsufficient
}
