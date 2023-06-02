//
//  CustomerHelper.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 02.06.23.
//

import Foundation

class CustomerHelper {
    
    static let shared = CustomerHelper()
    
    private var customer: Customer? = nil
    
    func createCustomer(with model: Customer) {
        customer = model
    }
    
    func getCustomer() -> Customer {
        return customer ?? Customer(name: "", surname: "", birthDate: "", gsmNumber: "")
    }
}
