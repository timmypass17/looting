//
//  GiveawayCollectionViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/13/24.
//

import UIKit

class GiveawayCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "GiveawayCollectionViewCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true    // clip
        imageView.backgroundColor = .placeholderText
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
        
    let vstack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .secondarySystemBackground
        stackView.layer.cornerRadius = 8
        stackView.layer.masksToBounds = true    // for crop
        return stackView
    }()
    
    let textContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let tagView = GiveawayTypeTag()
    
    let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    let freeLabel: UILabel = {
        let label = UILabel()
        label.text = "Free"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let hstack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    let endTagView: TimeRemainingTag = {
        let tagView = TimeRemainingTag()
        tagView.tagLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        tagView.translatesAutoresizingMaskIntoConstraints = false
        return tagView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(vstack)
        addSubview(endTagView)
                
        hstack.addArrangedSubview(tagView)
        hstack.addArrangedSubview(UIView())
        hstack.addArrangedSubview(originalPriceLabel)
        hstack.addArrangedSubview(freeLabel)
        
        hstack.setCustomSpacing(8, after: originalPriceLabel)
        
        textContainer.addArrangedSubview(titleLabel)
        textContainer.addArrangedSubview(descriptionLabel)
        textContainer.addArrangedSubview(UIView())
//        textContainer.addArrangedSubview(originalPriceLabel)
        textContainer.addArrangedSubview(hstack)
        
        vstack.addArrangedSubview(imageView)
        vstack.addArrangedSubview(textContainer)
        
        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            vstack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            vstack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            vstack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            endTagView.topAnchor.constraint(equalTo: vstack.topAnchor, constant: 4),
            endTagView.leadingAnchor.constraint(equalTo: vstack.leadingAnchor, constant: 4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with giveaway: Giveaway) async {
        titleLabel.text = giveaway.title
        descriptionLabel.text = giveaway.description
        originalPriceLabel.attributedText = giveaway.worth.strikethrough
        originalPriceLabel.isHidden = giveaway.worth == "N/A"
        tagView.update(type: giveaway.type)
        endTagView.update(endDate: giveaway.endDate, dateType: .normal)
        
        let imageRequest = ImageAPIRequest(url: URL(string: giveaway.thumbnail)!)
        if let image = try? await sendRequest(imageRequest) {
            imageView.image = image
        }
    }
}
