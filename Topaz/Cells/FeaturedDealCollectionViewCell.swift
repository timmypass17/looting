//
//  FeaturedDealCollectionViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/21/24.
//

import UIKit

class FeaturedDealCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FeaturedDealCollectionViewCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .accent
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textColor = UIColor.label
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.addArrangedSubview(headlineLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        stackView.setCustomSpacing(10, after: subTitleLabel)
        stackView.addArrangedSubview(imageView)
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with game: Game, dealItem: DealItem) {
        headlineLabel.text = "Trending Games"
        titleLabel.text = game.title
        if let shop: Shop = Settings.shared.shops.first(where: { $0.id == dealItem.deal?.shop.id }) {
            subTitleLabel.text = shop.title
        }
        imageView.backgroundColor = .placeholderText
        
        Task {
            let imageRequest = ImageAPIRequest(url: URL(string: game.assets.banner600)!)
            if let image = try? await sendRequest(imageRequest) {
                imageView.image = image
                imageView.backgroundColor = .clear
            }
        }
    }
}
