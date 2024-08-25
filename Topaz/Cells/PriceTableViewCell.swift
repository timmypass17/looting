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
    
    var expireImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "clock"))
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.tintColor = .secondaryLabel
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 15),  // Set the desired width
            imageView.heightAnchor.constraint(equalToConstant: 15)  // Set the desired height
        ])
        return imageView
    }()
    
    let expireLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    let storeLowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    let storeHStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    let dateHStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var defaultTrailingConstraint: NSLayoutConstraint!
    var chevronTrailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        storeHStack.addArrangedSubview(storeLabel)
        storeHStack.addArrangedSubview(cutLabel)
        storeHStack.addArrangedSubview(regularLabel)
        storeHStack.addArrangedSubview(priceLabel)
        
        dateHStack.addArrangedSubview(expireImageView)
        dateHStack.addArrangedSubview(expireLabel)
        dateHStack.addArrangedSubview(UIView())
        dateHStack.addArrangedSubview(storeLowLabel)
        
        container.addArrangedSubview(storeHStack)
        container.addArrangedSubview(dateHStack)
        
        contentView.addSubview(container)
        
        defaultTrailingConstraint = container.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        chevronTrailingConstraint = container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            defaultTrailingConstraint
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with deal: Deal) {
        storeLabel.text = deal.shop.name
        cutLabel.update(cut: deal.cut)
        regularLabel.attributedText = deal.regular.amount.discountString()
        priceLabel.text = deal.price.amount.priceString()
        
        if let endDate = deal.endDate,
           let formattedDateString = formatISODate(endDate) {
            expireLabel.text = formattedDateString
            expireLabel.isHidden = false
            expireImageView.isHidden = false
        } else {
            expireLabel.text = ""
            expireLabel.isHidden = true
            expireImageView.isHidden = true
        }
        
        if let storeLowPrice = deal.storeLow?.amount {
            storeLowLabel.text = "Low: \(storeLowPrice.priceString())"
        }
    
        if deal.url != nil {
            accessoryType = .disclosureIndicator
            chevronTrailingConstraint.isActive = true
            defaultTrailingConstraint.isActive = false
        } else {
            accessoryType = .none
            chevronTrailingConstraint.isActive = false
            defaultTrailingConstraint.isActive = true
        }
        
        let onSale: Bool = deal.price.amount < deal.regular.amount
        if onSale {
            regularLabel.isHidden = false
            priceLabel.textColor = .accent
        } else {
            regularLabel.isHidden = true
            priceLabel.textColor = .label
        }
        
        if deal.endDate == nil && deal.storeLow?.amount == nil {
            if container.arrangedSubviews.contains(dateHStack) {
                container.removeArrangedSubview(dateHStack) // does not remove stack's children (either remove children explicity, or hide them)
                expireLabel.isHidden = true
                storeLowLabel.isHidden = true
            }
        } else {
            if !container.arrangedSubviews.contains(dateHStack) {
                container.addArrangedSubview(dateHStack)
                expireLabel.isHidden = false
                storeLowLabel.isHidden = false
            }
        }
    }
    
    func formatISODate(_ date: Date) -> String? {
//        // Create ISO8601DateFormatter to parse the input ISO 8601 date string
//        let isoDateFormatter = ISO8601DateFormatter()
//        isoDateFormatter.formatOptions = [.withInternetDateTime]
//        
//        // Parse the ISO 8601 date string to a Date object
//        guard let date = isoDateFormatter.date(from: dateString) else {
//            return nil
//        }
//        
        // Create a DateFormatter for the desired output format
        let customDateFormatter = DateFormatter()
        customDateFormatter.dateFormat = "MMMM d @ h:mma"
        customDateFormatter.amSymbol = "am"
        customDateFormatter.pmSymbol = "pm"
        
        // Convert the Date object to the desired format string
        return customDateFormatter.string(from: date)
    }
}
