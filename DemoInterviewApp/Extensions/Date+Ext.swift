//
//  Date+Ext.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 01.06.23.
//

import Foundation

extension Date {
    static var maximumBirthDate: Date {
        return Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    }
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter
    }()
    
    var formattedString: String {
        return Date.formatter.string(from: self)
    }
}
