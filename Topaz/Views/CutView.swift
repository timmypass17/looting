//
//  DiscountView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/26/24.
//

import UIKit

class CutView: UIView {

    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.font = .systemFont(ofSize: 16, weight: .bold)
        
        label.textColor = .accent
        
        return label
    }()
    
    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .accent.withAlphaComponent(0.25) /*.accent*/
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
        addSubview(label)
        
        // store constraints to update them later
        
        topConstraint = label.topAnchor.constraint(equalTo: topAnchor, constant: 4)
        bottomConstraint = label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        leadingConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        trailingConstraint = label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)

        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
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
            label.text = "-\(cut)%"
            isHidden = false
        }
    }
}
