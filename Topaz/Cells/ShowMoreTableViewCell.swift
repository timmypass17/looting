//
//  ShowMoreTableViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/9/24.
//

import UIKit

class ShowMoreTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ShowMoreTableViewCell"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Show More"
        label.textColor = .accent
        return label
    }()
    
    var acessoryImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    var container: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.spacing = 4
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(acessoryImageView)
        
        self.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
