//
//  LabelInputTextField.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 31.05.23.
//

import UIKit
import SnapKit

struct LabelInputTextFieldModel {
    let title: String
    let placeholder: String
}

class LabelInputTextField: UIView {
    
    var inputText: String {
        return inputTextField.text ?? ""
    }
    
    private lazy var stackView: UIStackView = .build {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var label: UILabel = .build {
        $0.textColor = .black.withAlphaComponent(0.6)
    }
    
    lazy var inputTextField: UITextField = .build {
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ item: LabelInputTextFieldModel) {
        label.text = item.title
        inputTextField.placeholder = item.placeholder
    }
}

private extension LabelInputTextField {
    func addViews() {
        addSubviewSnp(stackView, insets: .init(top: 8, left: 16, bottom: 8, right: 16))
        [label, inputTextField].forEach(stackView.addArrangedSubview)
        inputTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    func setupDesign() {
        inputTextField.borderStyle = .roundedRect
    }
}
