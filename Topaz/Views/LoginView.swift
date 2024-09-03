//
//  LoginView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 9/3/24.
//

import UIKit
import GoogleSignIn

protocol LoginViewDelegate: AnyObject {
    func loginView(_ sender: LoginView, didTapGoogleLoginButton: Bool)
}

class LoginView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in to view wishlist"
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .semibold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "An account is required to save games and receive deal notifications."
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let googleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton(frame: .zero)
        button.colorScheme = .dark
        button.style = .wide
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        return stackView
    }()
    
    weak var delegate: LoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        googleLoginButton.addAction(didTapGoogleSignIn(), for: .touchUpInside)

        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(descriptionLabel)
        container.addArrangedSubview(googleLoginButton)
        
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapGoogleSignIn() -> UIAction {
        return UIAction { [self] _ in
            delegate?.loginView(self, didTapGoogleLoginButton: true)
        }
    }
}
