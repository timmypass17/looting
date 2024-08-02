//
//  DealMediumCollectionViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/3/24.
//

import UIKit

class DealMediumCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DealMediumCollectionViewCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .placeholderText
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.text = "No tags"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    let discountPriceView: DiscountPriceView = {
        let view = DiscountPriceView()
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        return stackView
    }()
    
    var imageTask: Task<Void, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let ratingView = HCSStarRatingView()
        ratingView.value = 4.5
        ratingView.minimumValue = 0
        ratingView.maximumValue = 5
        ratingView.tintColor = .white
        ratingView.allowsHalfStars = true
        ratingView.backgroundColor = .systemBackground
        ratingView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        let ratingLabel = UILabel()
        ratingLabel.text = "4.5"
        ratingLabel.font = .preferredFont(forTextStyle: .caption1)

        let ratingContainer = UIStackView()
        ratingContainer.axis = .horizontal
        ratingContainer.spacing = 8
        ratingContainer.addArrangedSubview(ratingView)
        ratingContainer.addArrangedSubview(ratingLabel)
                
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(ratingContainer)
        stackView.addArrangedSubview(tagsLabel)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(discountPriceView)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(game: Game, dealItem: DealItem) {
        titleLabel.text = game.title.lowercased().capitalized
        if game.tags.count > 0 {
            tagsLabel.text = game.tags.prefix(2).joined(separator: ", ")
        }
        discountPriceView.update(regular: dealItem.deal!.regular.amount, amount: dealItem.deal!.price.amount, cut: dealItem.deal!.cut)
        
        imageTask?.cancel()
        imageView.image = nil
        
        imageTask = Task {
            if let assets = game.assets {
                let imageRequest = ImageAPIRequest(url: URL(string: assets.boxart)!)
                if let image = try? await sendRequest(imageRequest) {
                    imageView.image = image
                }
                
                imageTask = nil
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageView.image = nil
    }
}
