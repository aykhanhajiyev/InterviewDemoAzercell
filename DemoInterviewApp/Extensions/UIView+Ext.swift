//
//  UIView+Ext.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 01.06.23.
//

import UIKit

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
}
