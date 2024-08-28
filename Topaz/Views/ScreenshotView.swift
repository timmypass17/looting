//
//  ScreenshotView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/28/24.
//

import UIKit

class ScreenshotView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(imageURL: String) async {
        let imageRequest = ImageAPIRequest(url: URL(string: imageURL)!)
        if let image = try? await sendRequest(imageRequest) {
            imageView.image = image
        }
    }
}
