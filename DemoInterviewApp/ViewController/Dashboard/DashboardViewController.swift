//
//  DashboardViewController.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 31.05.23.
//

import UIKit
import TPKeyboardAvoiding

class DashboardViewController: UIViewController {
    
    private let phoneNumberFormatter = PhoneNumberFormatter()
    
    private lazy var scrollView: TPKeyboardAvoidingScrollView = .build {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var containerStackView: UIStackView = .build {
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    private lazy var datePicker: UIDatePicker = .build {
        $0.maximumDate = Date.maximumBirthDate
        $0.frame = .init(x: 0, y: 0, width: UIScreen.screenWidth, height: 200)
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.addTarget(self, action: #selector(didChangeDatePickerValue), for: .valueChanged)
    }
    
    private lazy var nameField: LabelInputTextField = .build {
        $0.configure(.init(title: "Name", placeholder: "Please enter your name"))
        $0.inputTextField.delegate = self
        $0.inputTextField.tag = DashboardInputTypes.name.rawValue
    }
    private lazy var surnameField: LabelInputTextField = .build {
        $0.configure(.init(title: "Surname", placeholder: "Please enter your surname"))
        $0.inputTextField.delegate = self
        $0.inputTextField.tag = DashboardInputTypes.surname.rawValue
    }
    private lazy var birthdateField: LabelInputTextField = .build {
        $0.configure(.init(title: "Birthdate", placeholder: "Please enter your birthdate"))
        $0.inputTextField.inputView = datePicker
        $0.inputTextField.delegate = self
        $0.inputTextField.tag = DashboardInputTypes.birthdate.rawValue
    }
    
    private lazy var phoneNumberField: LabelInputTextField = .build {
        $0.configure(.init(title: "Phone number", placeholder: "Please enter your phone number"))
        $0.inputTextField.keyboardType = .phonePad
        $0.inputTextField.text = "+994"
        $0.inputTextField.delegate = self
        $0.inputTextField.tag = DashboardInputTypes.phoneNumber.rawValue
    }
    
    private lazy var buttonsWrapperView: UIView = UIView()
    
    private lazy var buttonsStackView: UIStackView = .build {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fillEqually
    }
    
    private lazy var createButton: BaseButton = .build {
        $0.setTitle("Create account", for: .normal)
        $0.buttonEnabled = false
        $0.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupConstraints()
        
        hideKeyboardWhenTappedAround()
    }
}

// MARK: - Private methods

private extension DashboardViewController {
    
    func addSubviews() {
        view.addSubviewSnp(scrollView)
        scrollView.addSubviewSnp(containerStackView)
        
        buttonsWrapperView.addSubview(buttonsStackView)
        buttonsStackView.addSubview(createButton)
        
        [
            createButton
        ].forEach(buttonsStackView.addArrangedSubview)
        
        [
            nameField,
            surnameField,
            birthdateField,
            phoneNumberField,
            buttonsWrapperView
        ].forEach(containerStackView.addArrangedSubview)
    }
    
    func setupConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    @objc
    func didChangeDatePickerValue(_ datePicker: UIDatePicker) {
        birthdateField.inputTextField.text = datePicker.date.formattedString
    }
    
    @objc
    func didTapCreateButton() {
        let customer = Customer(
            name: nameField.inputText,
            surname: surnameField.inputText,
            birthDate: birthdateField.inputText,
            gsmNumber: phoneNumberField.inputText
        )
        CustomerHelper.shared.createCustomer(with: customer)
        let vc = CardListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension DashboardViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return true
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        guard textField.tag == DashboardInputTypes.phoneNumber.rawValue else {
            return true
        }
        
        let formattedText = phoneNumberFormatter.fullFormat(phone: updatedText)

        textField.text = formattedText
        
        changeButtonState()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeButtonState()
    }
    
    func changeButtonState() {
        if nameField.inputText.isEmpty ||
           surnameField.inputText.isEmpty ||
           birthdateField.inputText.isEmpty ||
            PhoneHelper.cleanPhoneNumber(number: phoneNumberField.inputText).count != 12
        {
            createButton.buttonEnabled = false
        } else {
            createButton.buttonEnabled = true
        }
    }
}
