//
//  DiscountView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/26/24.
//

import UIKit

class DiscountView: UIView {

    let discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .accent
        
        addSubview(discountLabel)

        NSLayoutConstraint.activate([
            discountLabel.topAnchor.constraint(equalTo: topAnchor),
            discountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            discountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),    // padding
            discountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
