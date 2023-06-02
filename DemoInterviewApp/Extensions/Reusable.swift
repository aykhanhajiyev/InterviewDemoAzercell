//
//  Reusable.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 01.06.23.
//

import Foundation

protocol Reusable: AnyObject {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        String(describing: self)
    }
}
