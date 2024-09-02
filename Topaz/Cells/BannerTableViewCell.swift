//
//  BannerTableViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/6/24.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "BannerTableViewCell"
    
    let coverView = BannerCoverView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        coverView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(coverView)
        
        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(equalTo: topAnchor),
            coverView.bottomAnchor.constraint(equalTo: bottomAnchor),
            coverView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(imageURL: String?) async {
        await coverView.update(imageURL: imageURL)
    }
}
