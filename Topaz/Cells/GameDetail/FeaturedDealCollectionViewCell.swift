//
//  FeaturedDealCollectionViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/21/24.
//

import UIKit

class FeaturedDealCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FeaturedDealCollectionViewCell"
    
    let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .accent
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textColor = UIColor.label
        label.setContentCompressionResistancePriority(.required, for: .vertical) // fix bug with being compressed and clipped
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = UIColor.secondaryLabel
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    let priceView = PriceView()
    
    let discountView = DiscountView()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true    // for crop
        imageView.backgroundColor = .placeholderText
        return imageView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let vstack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    let hstack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    let priceContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        vstack.addArrangedSubview(titleLabel)
        vstack.addArrangedSubview(subTitleLabel)
        
        hstack.addArrangedSubview(vstack)
        hstack.addArrangedSubview(UIView())
        hstack.addArrangedSubview(discountView)
        hstack.setCustomSpacing(10, after: discountView)
        hstack.addArrangedSubview(priceView)
        
        stackView.addArrangedSubview(headlineLabel)
        stackView.addArrangedSubview(hstack)

        stackView.setCustomSpacing(10, after: hstack)

        stackView.addArrangedSubview(imageView)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            discountView.topAnchor.constraint(equalTo: priceView.topAnchor),
            discountView.bottomAnchor.constraint(equalTo: priceView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with game: Game, dealItem: DealItem) async {
        headlineLabel.text = "Trending Games"
        titleLabel.text = game.title
        if let shop: Shop = Settings.shared.shops.first(where: { $0.id == dealItem.deal?.shop.id }) {
            subTitleLabel.text = shop.title
        }
        
        discountView.update(cut: dealItem.deal!.cut)
        priceView.update(current: dealItem.deal!.price.amount, regular: dealItem.deal!.regular.amount)
        
        imageView.image = nil

        if let assets = game.assets {
            let imageRequest = ImageAPIRequest(url: URL(string: assets.banner600)!)
            if let image = try? await sendRequest(imageRequest) {
                imageView.image = image
            }
        }
    }
}
