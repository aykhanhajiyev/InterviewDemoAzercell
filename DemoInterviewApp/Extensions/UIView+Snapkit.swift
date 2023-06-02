//
//  UIView+Snapkit.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 31.05.23.
//

import SnapKit
import UIKit

extension UIView {
    func addSubviewSnp(_ view: UIView, insets: UIEdgeInsets = .zero) {
        addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(insets.left)
            make.top.equalToSuperview().inset(insets.top)
            make.trailing.equalToSuperview().inset(insets.right)
            make.bottom.equalToSuperview().inset(insets.bottom)
        }
    }
}
