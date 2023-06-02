//
//  UITableView+Legacy.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 01.06.23.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type) where T: Reusable {
        register(cellType.self , forCellReuseIdentifier: cellType.identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T
        where T: Reusable {
            let bareCell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath)
            guard let cell = bareCell as? T else {
                fatalError(
                    "Failed to dequeue a cell with identifier \(T.identifier) matching type \(T.self). "
                        + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                        + "and that you registered the cell beforehand"
                )
            }
            return cell
    }
    
    func registerHeaderView(_ headerType: UITableViewHeaderFooterView.Type) {
        register(
            headerType.self,
            forHeaderFooterViewReuseIdentifier: String(describing: headerType)
        )
    }
}

