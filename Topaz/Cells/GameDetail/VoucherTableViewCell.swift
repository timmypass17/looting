//
//  VoucherTableViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/9/24.
//

import UIKit

class VoucherTableViewCell: UITableViewCell {
    static let reuseIdentifier = "VoucherTableViewCell"

    
    var tagImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "tag"))
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Coupon Code"
        label.textColor = .secondaryLabel
        return label
    }()
    
    var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    var container: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container.addArrangedSubview(tagImageView)
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(codeLabel)
                
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(voucher: String) {
        codeLabel.text = voucher
    }
}
