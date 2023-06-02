//
//  TransferViewController.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 02.06.23.
//

import UIKit

struct TransferInputData {
    let debitCard: DebitCard
}

class TransferViewController: UIViewController {
    
    var inputData: TransferInputData
    
    private var receiverCardNumbers: [DebitCard] = []
    
    // MARK: - Views
    
    private lazy var scrollView: UIScrollView = .build {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var receiverPicker: UIPickerView = .build {
        $0.delegate = self
        $0.dataSource = self
    }
    
    private lazy var stackView: UIStackView = .build {
        $0.spacing = 8
        $0.axis = .vertical
    }
    
    private lazy var senderField: LabelInputTextField = .build {
        $0.configure(.init(title: "Sender", placeholder: ""))
        $0.inputTextField.isEnabled = false
    }
    
    private lazy var senderBalanceField: LabelInputTextField = .build {
        $0.configure(.init(title: "Balance", placeholder: ""))
        $0.inputTextField.isEnabled = false
    }
    
    private lazy var receiverField: LabelInputTextField = .build {
        $0.configure(.init(title: "Receiver", placeholder: "Please choose receiver card"))
        $0.inputTextField.inputView = receiverPicker
    }
    
    private lazy var receiverAmount: LabelInputTextField = .build {
        $0.configure(.init(title: "Amount", placeholder: "Please enter amount"))
        $0.inputTextField.keyboardType = .decimalPad
    }
    
    private lazy var transferButton: BaseButton = .build {
        $0.setTitle("Transfer", for: .normal)
        $0.addTarget(self, action: #selector(didTapTransferButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Transfer between my cards"
        senderField.inputTextField.text = inputData.debitCard.cardNumber
        senderBalanceField.inputTextField.text = "\(inputData.debitCard.balance) AZN"
        
        hideKeyboardWhenTappedAround()
        addSubviews()
        
        fetchData()
    }
    
    init(inputData: TransferInputData) {
        self.inputData = inputData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension TransferViewController {
    func addSubviews() {
        view.addSubviewSnp(scrollView)
        
        scrollView.addSubviewSnp(stackView)
        
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        transferButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        [
            senderField,
            senderBalanceField,
            receiverField,
            receiverAmount,
            transferButton
        ].forEach(stackView.addArrangedSubview)
    }
    
    func fetchData() {
        receiverCardNumbers = DebitCardHelper.shared.debitCards.filter({$0.cardNumber != inputData.debitCard.cardNumber})
    }
    
    @objc
    func didTapTransferButton() {
        let result = DebitCardHelper.shared.startTransaction(sender: inputData.debitCard, receiverCardNumber: receiverField.inputText, amount: Double(receiverAmount.inputText) ?? 0.0)
        switch result {
        case .success:
            "Your transfer has been successfully".show(.success)
            NotificationCenter.default.post(name: .reloadCardList, object: nil)
            self.navigationController?.popViewController(animated: true)
        case .receiverNotFounded:
            "Receiver not found".show(.error)
        case .senderAmountInsufficient:
            "Sender amount is not sufficient".show(.warning)
        }
    }
}

// MARK: - UIPickerViewDelegeta
extension TransferViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        receiverCardNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return receiverCardNumbers[row].cardNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        receiverField.inputTextField.text = receiverCardNumbers[row].cardNumber
    }
    
}
