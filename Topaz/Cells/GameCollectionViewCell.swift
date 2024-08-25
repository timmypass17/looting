//
//  GameCollectionViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/21/24.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GameCollectionViewCell"

    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true    // for crop
        imageView.contentMode = .scaleAspectFill
        let height: CGFloat = 100
        imageView.widthAnchor.constraint(equalToConstant: (600/344) * height).isActive = true
        return imageView
    }()
    
    let vstack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let hstack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let priceHStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    let priceView = PriceView()
    
    let discountView = DiscountView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        layer.masksToBounds = true    // for crop
        backgroundColor = .secondarySystemGroupedBackground
        
        addSubview(container)
        
        hstack.addArrangedSubview(createdAtLabel)
//        hstack.addArrangedSubview(tagsLabel)
        
        priceHStack.addArrangedSubview(UIView())
        priceHStack.addArrangedSubview(discountView)
        priceHStack.setCustomSpacing(10, after: discountView)
        priceHStack.addArrangedSubview(priceView)
        
        vstack.addArrangedSubview(titleLabel)
        vstack.addArrangedSubview(hstack)
//        vstack.addArrangedSubview(descriptionLabel)
        vstack.addArrangedSubview(UIView())
        vstack.addArrangedSubview(priceHStack)
        
        container.addArrangedSubview(coverImageView)
        container.addArrangedSubview(vstack)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leftAnchor.constraint(equalTo: leftAnchor),
            container.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(game: Game, dealItem: DealItem) async {
        titleLabel.text = game.title
        createdAtLabel.text = Date().formatted(date: .abbreviated, time: .omitted)
        descriptionLabel.text = "Description here"
        if let assets = game.assets {
            let imageRequest = ImageAPIRequest(url: URL(string: assets.banner600)!)
            if let image = try? await sendRequest(imageRequest) {
                coverImageView.image = image
            }
        }
        
        priceView.update(current: dealItem.deal?.price.amount, regular: dealItem.deal!.regular.amount)
        discountView.update(cut: dealItem.deal!.cut)
    }
}
