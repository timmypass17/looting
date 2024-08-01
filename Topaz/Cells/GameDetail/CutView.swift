//
//  CutView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/6/24.
//

import UIKit

class CutView: UIView {

    let discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .accent
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
        addSubview(discountLabel)
        
        NSLayoutConstraint.activate([
            discountLabel.topAnchor.constraint(equalTo: topAnchor),
            discountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            discountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),    // padding
            discountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
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
