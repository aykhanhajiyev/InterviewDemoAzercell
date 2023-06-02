//
//  BaseButton.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 01.06.23.
//

import UIKit

class BaseButton: UIButton {
    
    var buttonEnabled: Bool = true {
        didSet {
            changeStateStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BaseButton {
    func setupDesign() {
        backgroundColor = .blue
        setTitleColor(.white, for: .normal)
        roundCorners(.allCorners, radius: 8)
    }
    
    func changeStateStyle() {
        isEnabled = buttonEnabled
        backgroundColor = buttonEnabled ? .blue : .blue.withAlphaComponent(0.2)
    }
}
