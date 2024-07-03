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
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.text = "No tags"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    let discountPriceView = DiscountPriceView()
    
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
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(tagsLabel)
        stackView.addArrangedSubview(discountPriceView)
        
        stackView.setCustomSpacing(10, after: tagsLabel)

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
        ratingLabel.text = "***** 4.5"
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
