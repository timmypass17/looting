//
//  Test.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/27/24.
//

import UIKit

class TestView: UIView {

    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .gray
        return stackView
    }()
    
    
    let hstack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .red
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "%20"
        return label
    }()
    
    let vstack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .blue
        stackView.alignment = .trailing
        return stackView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
//        label.text = "$20.00"
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    let discountLabel: UILabel = {
        let label = UILabel()
//        label.text = "$15.00"
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        vstack.addArrangedSubview(priceLabel)
        vstack.addArrangedSubview(discountLabel)
        
        hstack.addArrangedSubview(label)
        hstack.addArrangedSubview(vstack)
        
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(hstack)
//        container.addArrangedSubview(vstack)

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

#Preview {
    TestView()
}
