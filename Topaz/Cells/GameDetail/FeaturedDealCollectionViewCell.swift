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
        label.numberOfLines = 1
        return label
    }()
    
    let priceView = PriceView()
    
    let cutView = CutView()
    
    let coverView = LargeCoverView()
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 8
//        imageView.layer.masksToBounds = true    // for crop
//        imageView.backgroundColor = .secondarySystemBackground
//        imageView.tintColor = .placeholderText
//        NSLayoutConstraint.activate([
//            imageView.heightAnchor.constraint(equalToConstant: 230)
//        ])
//    
//        return imageView
//    }()
    
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
        stackView.spacing = 10
        return stackView
    }()
    
    let priceVStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    let endTagView: TimeRemainingTag = {
        let tagView = TimeRemainingTag()
        tagView.tagLabel.font = .preferredFont(forTextStyle: .subheadline)
        NSLayoutConstraint.activate([
            tagView.imageView.heightAnchor.constraint(equalToConstant: 30),
            tagView.imageView.widthAnchor.constraint(equalToConstant: 30)
        ])
        tagView.translatesAutoresizingMaskIntoConstraints = false
        return tagView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        vstack.addArrangedSubview(titleLabel)
        vstack.addArrangedSubview(subTitleLabel)
        
        priceContainer.addArrangedSubview(cutView)
        priceContainer.addArrangedSubview(priceView)
                
        hstack.addArrangedSubview(vstack)
        hstack.addArrangedSubview(UIView())
        hstack.addArrangedSubview(priceContainer)
                
        stackView.addArrangedSubview(headlineLabel)
        stackView.addArrangedSubview(hstack)
        stackView.setCustomSpacing(10, after: hstack)

//        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(coverView)
        
        addSubview(stackView)
        addSubview(endTagView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cutView.topAnchor.constraint(equalTo: priceView.topAnchor),
            cutView.bottomAnchor.constraint(equalTo: priceView.bottomAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            endTagView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 4),
//            endTagView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 4)
//        ])
        
        NSLayoutConstraint.activate([
            endTagView.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 4),
            endTagView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with game: Game, dealItem: DealItem) async {
        headlineLabel.text = "Trending Games"
        titleLabel.text = game.title
        subTitleLabel.text = game.tags.prefix(2).map { $0 }.joined(separator: ", ")
        
        cutView.update(cut: dealItem.deal!.cut)
        priceView.update(current: dealItem.deal!.price.amount, regular: dealItem.deal!.regular.amount)
        
        await coverView.update(imageURL: game.assets?.banner600)
//        imageView.image = nil
//
//        if let assets = game.assets {
//            let imageRequest = ImageAPIRequest(url: URL(string: assets.banner600)!)
//            if let image = try? await sendRequest(imageRequest) {
//                imageView.contentMode = .scaleAspectFill
//                imageView.image = image
//            } else {
//                imageView.contentMode = .scaleAspectFit
//                imageView.image = UIImage(systemName: "gamecontroller")
//            }
//        } else {
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = UIImage(systemName: "gamecontroller")
//        }
        
        endTagView.update(endDate: dealItem.deal?.endDate, dateType: .normal)
    }
}


