//
//  StoreDealsCollectionViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/21/24.
//

import UIKit

class DealSmallCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "DealSmallCollectionViewCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
//        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true    // for crop
        imageView.backgroundColor = .placeholderText
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200/4 * (400/187)),
            imageView.heightAnchor.constraint(equalToConstant: 200/4)
        ])
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
//        stackView.backgroundColor = .blue
        return stackView
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
//        stackView.backgroundColor = .secondaryLabel
        return stackView
    }()
    
    let regularLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    let saleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.font = .systemFont(ofSize: 16, weight: .bold)
//        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    
//    let installButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
//        button.layer.cornerRadius = 12
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//        button.setTitleColor(.systemBlue, for: .normal)
//        button.setContentHuggingPriority(.required, for: .horizontal)
//        button.widthAnchor.constraint(equalToConstant: 65).isActive = true
//        
//        return button
//    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        labelStackView.addArrangedSubview(titleLabel)
        
        priceStackView.addArrangedSubview(regularLabel)
        priceStackView.addArrangedSubview(saleLabel)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(priceStackView)
        
        addSubview(stackView)
        addSubview(lineView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
//            lineView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            lineView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: priceStackView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with game: Game, _ dealItem: DealItem, hideBottomLine: Bool) {
        titleLabel.text = game.title
        subtitleLabel.text = "Description"
//        regularLabel.text = "$\(dealItem.deal!.regular.amount)"
        saleLabel.text = "$\(dealItem.deal!.price.amount)"
        
        lineView.isHidden = hideBottomLine
        
        Task {
            let imageRequest = ImageAPIRequest(url: URL(string: game.assets.banner400)!)
            if let image = try? await sendRequest(imageRequest) {
                imageView.image = image
                imageView.backgroundColor = .clear
            }
        }
        
        let attributeString = NSMutableAttributedString(string: "$\(dealItem.deal!.regular.amount)")
        attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
        
        regularLabel.attributedText = attributeString
    }
}
