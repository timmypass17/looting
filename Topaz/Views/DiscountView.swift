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
        
        label.textColor = .accent
        
        return label
    }()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .accent.withAlphaComponent(0.25) /*.accent*/
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
        addSubview(discountLabel)
        
        // store constraints to update them later
        leadingConstraint = discountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        trailingConstraint = discountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)

        NSLayoutConstraint.activate([
            discountLabel.topAnchor.constraint(equalTo: topAnchor),
            discountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            leadingConstraint,
            trailingConstraint,
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(cut: Int) {
        if cut == 0 {
            isHidden = true
        } else {
            discountLabel.text = "-\(cut)%"
            isHidden = false
        }
    }
}
