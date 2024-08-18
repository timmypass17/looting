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
        imageView.contentMode = .scaleAspectFill
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

    let priceView = PriceView()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let endTagView: TagView = {
        let tagView = TagView()
        tagView.tagLabel.font = .preferredFont(forTextStyle: .caption1)
        NSLayoutConstraint.activate([
            tagView.imageView.heightAnchor.constraint(equalToConstant: 20),
            tagView.imageView.widthAnchor.constraint(equalToConstant: 20)
        ])

        return tagView
    }()
    
    let vstack: UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        return vstack
    }()
    
    let hstack: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        return hstack
    }()
    
    let spacer: UIView = {
        return UIView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hstack.addArrangedSubview(endTagView)
        hstack.addArrangedSubview(spacer)
        
        vstack.addArrangedSubview(titleLabel)
        vstack.addArrangedSubview(hstack)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(vstack)
        stackView.addArrangedSubview(priceView)
        
        addSubview(stackView)
        addSubview(lineView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            lineView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: priceView.trailingAnchor)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(title: String, imageURL: String?, deal: Deal?, hideBottomLine: Bool = false) async {
        titleLabel.text = title
        priceView.update(current: deal?.price.amount, regular: deal!.regular.amount)
        lineView.isHidden = hideBottomLine
        
        if let imageURL {
            let imageRequest = ImageAPIRequest(url: URL(string: imageURL)!)
            if let image = try? await sendRequest(imageRequest) {
                imageView.image = image
            }
        } else {
            imageView.image = nil
        }
        
        if let endDate = deal?.endDate {
            // does not add duplicates
            hstack.addArrangedSubview(endTagView)
            hstack.addArrangedSubview(spacer)
            vstack.addArrangedSubview(hstack)
            endTagView.update(endDate: endDate, dateType: .short)
        } else {
            hstack.removeArrangedSubview(endTagView)
            hstack.removeArrangedSubview(spacer)
            vstack.removeArrangedSubview(hstack)
            
            endTagView.removeFromSuperview()
            spacer.removeFromSuperview()
            hstack.removeFromSuperview()
        }
    }
    
}

// TODO: deal isnt shown to lowest deal (ex. Sin of a Solar...)
