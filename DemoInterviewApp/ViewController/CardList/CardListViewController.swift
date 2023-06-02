//
//  CardListViewController.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 01.06.23.
//

import UIKit

final class CardListViewController: UIViewController {
    
    private var cardList: [CardListItemTableViewCellModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = .build {
        $0.delegate = self
        $0.dataSource = self
        $0.register(cellType: CardListItemTableViewCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Card list"
        view.backgroundColor = .white
        view.addSubviewSnp(tableView)
        addRightBarButtonItem()
        
        fetchData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateList), name: .reloadCardList, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .reloadCardList, object: nil)
    }
    
}

// MARK: - Private methods
private extension CardListViewController {
    
    func fetchData() {
        cardList = DebitCardHelper.shared.debitCards.map({ item in
            CardListItemTableViewCellModel(debitCard: item) { [weak self] in
                self?.redirectTransferScreen(item)
            }
        })
    }
    
    func addRightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapRightButton))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc
    func didTapRightButton() {
        let alertModel = AlertModel(title: "Card details", subtitle: "Please enter your card 16 digits numbers", placeholder: "", buttonTitle: "Add card") { [weak self] inputText in
            self?.createDebitCard(inputText)
        }
        AlertHelper.shared.createAlertWithTextField(with: alertModel, sender: self)
    }
    
    func createDebitCard(_ cardNumber: String?) {
        if let cardNumber = cardNumber, cardNumber.count == 19, cardNumber.isEmpty.not {
            let debitCard = DebitCard(cardNumber: cardNumber)
            DebitCardHelper.shared.addDebitCardToCustomer(debitCard)
            fetchData()
            "Card has been added".show(.success)
        } else {
            "Card information is not correct".show(.warning)
        }
    }
    
    func redirectTransferScreen(_ debitCard: DebitCard) {
        let vc = TransferViewController(inputData: .init(debitCard: debitCard))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func updateList() {
        fetchData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CardListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CardListItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(cardList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let card = cardList[indexPath.row]
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            DebitCardHelper.shared.removeDebitCardFromCustomer(card.cardNumber)
            self?.fetchData()
            "Selected card has been deleted".show(.success)
        }
        let config = UISwipeActionsConfiguration(actions: [action])
        return config
    }
}

// MARK: - UITextFieldDelegate
extension CardListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count == 19, string != "" {
            return false
        } else {
            textField.text = textField.text?.textPattern()
            return true
        }
    }
}
