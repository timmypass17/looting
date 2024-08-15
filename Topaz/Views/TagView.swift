//
//  TagView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/14/24.
//

import UIKit

class TagView: UIView {

    let label: UILabel = {
        let label = UILabel()
        label.text = "Game"
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .preferredFont(forTextStyle: .caption1)
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),

        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with type: GiveawayType) {
        switch type {
        case .game:
            label.text = "Game"
            backgroundColor = .systemGreen.withAlphaComponent(0.25)
            label.textColor = .systemGreen
        case .dlc:
            label.text = "Loot"
            backgroundColor = .systemBlue.withAlphaComponent(0.25)
            label.textColor = .systemBlue
        case .earlyAccess:
            label.text = "Early Access"
            backgroundColor = .systemPurple.withAlphaComponent(0.25)
            label.textColor = .systemPurple
        case .other:
            label.text = "Other"
            backgroundColor = .systemGray.withAlphaComponent(0.25)
            label.textColor = .systemGray
        }
    }
}
