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
    
    let coverImage = SmallCoverView()
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.masksToBounds = true    // for crop
//        imageView.backgroundColor = .secondarySystemBackground
//        imageView.tintColor = .placeholderText
//        
//        NSLayoutConstraint.activate([
//            imageView.widthAnchor.constraint(equalToConstant: 60 * (400/187)),
//            imageView.heightAnchor.constraint(equalToConstant: 60)
//        ])
//        
//        return imageView
//    }()
    
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
    
    let endTagView: TimeRemainingTag = {
        let tagView = TimeRemainingTag()
        tagView.tagLabel.textColor = .secondaryLabel
        tagView.imageView.tintColor = .secondaryLabel
        tagView.backgroundColor = nil
        
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
        hstack.spacing = 4
        return hstack
    }()
        
    let cutView: CutView = {
        let view = CutView()
        view.label.font = .systemFont(ofSize: 12, weight: .bold)
        view.topConstraint.constant = 4
        view.bottomConstraint.constant = -4
        view.leadingConstraint.constant = 4
        view.trailingConstraint.constant = -4
        view.layoutIfNeeded()
        return view
    }()
    
    let priceContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    let spacer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        priceContainer.addArrangedSubview(cutView)
        priceContainer.addArrangedSubview(priceView)

        vstack.addArrangedSubview(titleLabel)
        
        stackView.addArrangedSubview(coverImage)
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
            lineView.bottomAnchor.constraint(equalTo: coverImage.bottomAnchor),
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
        cutView.update(cut: deal!.cut)
        lineView.isHidden = hideBottomLine
        endTagView.update(endDate: deal?.endDate, dateType: .normal)
        
        Task {
            await setImage(imageURL: imageURL)
        }
        
        if let cut = deal?.cut, cut > 0 {
            hstack.addArrangedSubview(cutView)
            hstack.addArrangedSubview(endTagView)
            hstack.addArrangedSubview(spacer)
            vstack.addArrangedSubview(hstack)
        } else {
            // Have to removeArrangedSubview and removeFromSuperview
            // https://developer.apple.com/documentation/uikit/uistackview/1616235-removearrangedsubview
            hstack.removeArrangedSubview(cutView)
            hstack.removeArrangedSubview(endTagView)
            hstack.removeArrangedSubview(spacer)
            vstack.removeArrangedSubview(hstack)

            cutView.removeFromSuperview()
            endTagView.removeFromSuperview()
            spacer.removeFromSuperview()
            hstack.removeFromSuperview()
        }
    }
    
    func setImage(imageURL: String?) async {
        await coverImage.update(imageURL: imageURL)
//        if let imageURL {
//            let imageRequest = ImageAPIRequest(url: URL(string: imageURL)!)
//            if let image = try? await sendRequest(imageRequest) {
//                imageView.contentMode = .scaleAspectFill
//                imageView.image = image
//            } else {
//                imageView.contentMode = .scaleAspectFit
//                imageView.image = UIImage(systemName: "gamecontroller")
//                
//            }
//        } else {
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = UIImage(systemName: "gamecontroller")
//        }
    }
}
