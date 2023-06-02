//
//  CardListItemTableViewCell.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 01.06.23.
//

import UIKit

struct CardListItemTableViewCellModel {
    let cardNumber: String
    let leftTitle: String
    let rightTitle: String
    let transferButtonAction: ()->()
    
    init(debitCard: DebitCard, transferAction: @escaping ()->()) {
        self.cardNumber = debitCard.cardNumber
        self.leftTitle = debitCard.cardNumber
        self.rightTitle = "\(debitCard.balance) AZN"
        self.transferButtonAction = transferAction
    }
}

final class CardListItemTableViewCell: UITableViewCell, Reusable {
    
    private var model: CardListItemTableViewCellModel? = nil
    
    private lazy var stackView: UIStackView = .build {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    private lazy var leftTitleLabel: UILabel = .build {
        $0.textColor = .black.withAlphaComponent(0.6)
    }
    
    private lazy var rightTitleLabel: UILabel = .build {
        $0.textColor = .black
    }
    
    private lazy var transferButton: BaseButton = .build {
        $0.setTitle("Transfer", for: .normal)
        $0.addTarget(self, action: #selector(didTapTransferButton), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        transferButton.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func configure(_ item: CardListItemTableViewCellModel) {
        model = item
        leftTitleLabel.text = item.leftTitle
        rightTitleLabel.text = item.rightTitle
    }
}

private extension CardListItemTableViewCell {
    func setup() {
        selectionStyle = .none
        contentView.addSubviewSnp(stackView, insets: .init(top: 8, left: 16, bottom: 8, right: 16))
        [
            leftTitleLabel,
            rightTitleLabel,
            transferButton
        ].forEach(stackView.addArrangedSubview)
    }
    
    @objc
    func didTapTransferButton() {
        model?.transferButtonAction()
    }
}
