//
//  PriceTableViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/6/24.
//

import UIKit

class PriceTableViewCell: UITableViewCell {
    static let reuseIdentifier = "PriceTableViewCell"
    
    let storeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let cutLabel = CutView()
        
    let regularLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accent
        return label
    }()
    
    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()
    
    var defaultTrailingConstraint: NSLayoutConstraint!
    var chevronTrailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container.addArrangedSubview(storeLabel)
        container.addArrangedSubview(cutLabel)
        container.addArrangedSubview(regularLabel)
        container.addArrangedSubview(priceLabel)
        
        contentView.addSubview(container)
        
        defaultTrailingConstraint = container.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        chevronTrailingConstraint = container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            defaultTrailingConstraint
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with deal: Deal) {
        let attributeString = NSMutableAttributedString(string: "$\(String(format: "%.2f", deal.regular.amount))")
        attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
        
        storeLabel.text = deal.shop.name
        cutLabel.setCut(cut: deal.cut)
        regularLabel.attributedText = attributeString
        priceLabel.text = "$\(String(format: "%.2f", deal.price.amount))"
        
        if deal.url != nil {
            accessoryType = .disclosureIndicator
            if defaultTrailingConstraint.isActive {
                defaultTrailingConstraint.isActive = false
            }
            chevronTrailingConstraint.isActive = true
        } else {
            accessoryType = .none
            if chevronTrailingConstraint.isActive {
                chevronTrailingConstraint.isActive = false
            }
            defaultTrailingConstraint.isActive = true
        }
        
        let onSale: Bool = deal.price.amount < deal.regular.amount
        if onSale {
            cutLabel.isHidden = false
            regularLabel.isHidden = false
            priceLabel.textColor = .accent
        } else {
            cutLabel.isHidden = true
            regularLabel.isHidden = true
            priceLabel.textColor = .secondaryLabel
        }
    }
}
