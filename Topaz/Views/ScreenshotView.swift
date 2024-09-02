//
//  ScreenshotView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/28/24.
//

import UIKit

class MediaView: UIView {
    
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

class MovieView: MediaView {
    
    let playView: PlayView = {
        let view = PlayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleView: MovieTitleView = {
        let view = MovieTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(playView)
        addSubview(titleView)
        
        NSLayoutConstraint.activate([
            playView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            playView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(title: String, imageURL: String) async {
        titleView.label.text = title
        await super.update(imageURL: imageURL)
    }
}

class PlayView: UIView {
    
    let playImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.fill")!
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.8)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
        addSubview(playImageView)
        
        NSLayoutConstraint.activate([
            playImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            playImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            playImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            playImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MovieTitleView: UIView {
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .italicSystemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.8)
        layer.cornerRadius = 2
        layer.masksToBounds = true
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

