//
//  PriceView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/26/24.
//

import UIKit

class PriceView: UIView {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
//        stackView.alignment = .trailing   // this causes view to stretch for some reason
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let secondaryPriceLabel: UILabel = {
        let label = UILabel()
//        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .right    // Fixed!
        label.setContentCompressionResistancePriority(.required, for: .horizontal)   // never compress text to ...
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
//        label.textColor = .accent
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right    // Fixed!
        label.setContentCompressionResistancePriority(.required, for: .horizontal)   // never compress text to ...
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        stackView.addArrangedSubview(secondaryPriceLabel)
        stackView.addArrangedSubview(priceLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(current: Double?, regular: Double) {
        let isFree = regular == 0
        if isFree {
            secondaryPriceLabel.isHidden = true
            priceLabel.text = "Free"
            priceLabel.textColor = .white
            priceLabel.isHidden = false
            return
        }
        
        guard let current else {
            secondaryPriceLabel.isHidden = true
            priceLabel.text = regular.priceString()
            priceLabel.textColor = .white
            return
        }
        
        let isOnSale = current < regular
        if isOnSale {
            secondaryPriceLabel.attributedText = regular.discountString()
            secondaryPriceLabel.isHidden = false
            secondaryPriceLabel.textColor = .secondaryLabel
            
            priceLabel.text = current.priceString()
            priceLabel.textColor = .accent
        } else {
            secondaryPriceLabel.isHidden = true
            priceLabel.text = current.priceString()
            priceLabel.textColor = .white
        }
    }
    
    func update(giveaway: Giveaway) {
        priceLabel.text = "Free"
        secondaryPriceLabel.attributedText = giveaway.worth.strikethrough
        secondaryPriceLabel.textColor = .secondaryLabel
        secondaryPriceLabel.isHidden = giveaway.worth == "N/A"
    }
}

extension Double {
    func priceString() -> String {
        return  "$\(String(format: "%.2f", self))"
    }
    
    func discountString() -> NSMutableAttributedString {
        return self.priceString().strikethrough
    }
}

extension String {
    var strikethrough: NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }
}
