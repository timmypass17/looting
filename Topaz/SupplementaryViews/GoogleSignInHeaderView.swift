//
//  GoogleSignInHeaderView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/16/24.
//

import UIKit
import GoogleSignIn

protocol GoogleSignInHeaderViewDelegate: AnyObject {
    func googleSignInHeaderViewDelegate(_ sender: GoogleSignInHeaderView, didTapSignIn: Bool)
}

class GoogleSignInHeaderView: UIView {
    
    let googleSignInButton: GIDSignInButton = {
        let button = GIDSignInButton(frame: .zero)
        button.colorScheme = .dark
        button.style = .wide
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: GoogleSignInHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        googleSignInButton.addAction(didTapGoogleSignIn(), for: .touchUpInside)
        
        addSubview(googleSignInButton)
        
        NSLayoutConstraint.activate([
            googleSignInButton.topAnchor.constraint(equalTo: topAnchor),
            googleSignInButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            googleSignInButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            googleSignInButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapGoogleSignIn() -> UIAction {
        return UIAction { _ in
            self.delegate?.googleSignInHeaderViewDelegate(self, didTapSignIn: true)
        }
    }
}
