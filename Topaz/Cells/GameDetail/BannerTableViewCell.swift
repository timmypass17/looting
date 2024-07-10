//
//  BannerTableViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/6/24.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "BannerTableViewCell"
    
    let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true    // for crop
        imageView.backgroundColor = .placeholderText
        
        let width = UIScreen.main.bounds.size.width
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: width * (344/600))
        ])
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bannerImageView)
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: topAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(url: URL) async {
        let imageRequest = ImageAPIRequest(url: url)
        if let image = try? await sendRequest(imageRequest) {
            bannerImageView.image = image
        }
    }
}
