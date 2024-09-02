//
//  LargeCoverView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 9/2/24.
//

import UIKit

class CoverView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .placeholderText
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var padding: CGFloat { return 30 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondarySystemBackground
        layer.masksToBounds = true    // for crop

        addSubview(imageView)
        
        topConstraint = imageView.topAnchor.constraint(equalTo: topAnchor)
        bottomConstraint = imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        leadingConstraint = imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        trailingConstraint = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leadingConstraint,
            trailingConstraint,
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(imageURL: String?) async {
        if let imageURL {
            let imageRequest = ImageAPIRequest(url: URL(string: imageURL)!)
            if let image = try? await sendRequest(imageRequest) {
                topConstraint.constant = 0
                bottomConstraint.constant = 0
                leadingConstraint.constant = 0
                trailingConstraint.constant = 0
                imageView.contentMode = .scaleAspectFill
                imageView.image = image
            } else {
                topConstraint.constant = padding
                bottomConstraint.constant = -padding
                leadingConstraint.constant = padding
                trailingConstraint.constant = -padding
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(systemName: "gamecontroller")
            }
        } else {
            topConstraint.constant = padding
            bottomConstraint.constant = -padding
            leadingConstraint.constant = padding
            trailingConstraint.constant = -padding
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(systemName: "gamecontroller")
        }
    }
}

class LargeCoverView: CoverView {
    
    override var padding: CGFloat { return 30 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 230)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MediumCoverView: CoverView {
    
    override var padding: CGFloat { return 10 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SmallCoverView: CoverView {
    
    override var padding: CGFloat { return 8 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 60 * (400/187)),
            heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BannerCoverView: CoverView {
    
    override var padding: CGFloat { return 30 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: (344 / 600) * self.frame.size.width)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
