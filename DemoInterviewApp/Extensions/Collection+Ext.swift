//
//  Collection+Ext.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 01.06.23.
//

import Foundation

extension Collection {
    func count(where predicate: (Element) -> Bool) -> Int {
        var count = 0
        for element in self where predicate(element) {
            count += 1
        }
        return count
    }
}
