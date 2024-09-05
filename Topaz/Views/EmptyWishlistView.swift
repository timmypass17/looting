//
//  EmptyWishlistView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 9/4/24.
//

import UIKit

class EmptyWishlistView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "👾 No Games"
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .semibold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "New wishlisted games will appear here."
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        return stackView
    }()
            
    override init(frame: CGRect) {
        super.init(frame: frame)

        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(descriptionLabel)
                
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


