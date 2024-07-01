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
    
    let regularLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .right    // Fixed!
        label.setContentCompressionResistancePriority(.required, for: .horizontal)   // never compress text to ...
        return label
    }()
    
    let saleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right    // Fixed!
        label.setContentCompressionResistancePriority(.required, for: .horizontal)   // never compress text to ...
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .blue
        
        stackView.addArrangedSubview(regularLabel)
        stackView.addArrangedSubview(saleLabel)
        
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
    
//    func update(price: Double, discountedPrice: Double) {
//        let attributeString = NSMutableAttributedString(string: "$\(price)")
//        attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
//        
//        regularLabel.attributedText = attributeString
//        saleLabel.text = "$\(discountedPrice)"
//    }
}
