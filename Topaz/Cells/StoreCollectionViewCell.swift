//
//  StoreCollectionViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/24/24.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "StoreCollectionViewCell"
    
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 6
//        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        imageView.backgroundColor = .placeholderText
//        return imageView
//    }()
//    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .label
        return label
    }()
    
    let dealCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dealCountLabel)
        
        addSubview(stackView)
        addSubview(lineView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with shop: Shop, hideBottomLine: Bool) {
        titleLabel.text = shop.title
        dealCountLabel.text = "\(shop.deals)"
        lineView.isHidden = hideBottomLine
//        Task {
//            let imageRequest = ImageAPIRequest(url: URL(string: "https://www.cheapshark.com\(store.images.icon)")!)
//            if let image = try? await sendRequest(imageRequest) {
//                imageView.image = image
//                imageView.backgroundColor = .clear
//            }
//        }
    }
}
