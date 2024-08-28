//
//  BackgroundView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/6/24.
//

import UIKit

class GameBackgroundView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let blackOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.80) // Adjust the alpha as needed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        addSubview(imageView)
        imageView.addSubview(blackOverlayView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            blackOverlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            blackOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            blackOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            blackOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(url: URL) async {
        let imageRequest = ImageAPIRequest(url: url)
        if let image = try? await sendRequest(imageRequest) {
            imageView.image = image
        }
    }
}
