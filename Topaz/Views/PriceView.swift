//
//  PriceView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/26/24.
//

// TODO: Make discounted text (crossed out) semi bold
//  - Change tags to use opaque version
import UIKit

class PriceView: UIView {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let secondaryPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .right    // Fixed!
        label.setContentCompressionResistancePriority(.required, for: .horizontal)   // never compress text to ...
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right    // Fixed!
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
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
        let isAlwaysFree = regular == 0
        if isAlwaysFree {
            secondaryPriceLabel.isHidden = true
            priceLabel.text = "Free"
            priceLabel.textColor = .label
            priceLabel.isHidden = false
            return
        }
        
        guard let current else {
            secondaryPriceLabel.isHidden = true
            priceLabel.text = regular.priceString()
            priceLabel.textColor = .label
            return
        }
        
        let isOnSale = current < regular
        if isOnSale {
            let isNowFree = current == 0
            if isNowFree {
                priceLabel.text = "Free"
                priceLabel.textColor = .label
            } else {
                priceLabel.text = current.priceString()
                priceLabel.textColor = .accent
            }
            
            secondaryPriceLabel.attributedText = regular.discountString()
            secondaryPriceLabel.textColor = .secondaryLabel
            secondaryPriceLabel.isHidden = false
        } else {
            secondaryPriceLabel.isHidden = true
            priceLabel.text = current.priceString()
            priceLabel.textColor = .label
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
