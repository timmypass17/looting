//
//  WishlistViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class WishlistViewController: UIViewController {
    
    let button: GIDSignInButton = {
        let button = GIDSignInButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addAction(didTapGoogleSignIn(), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func didTapGoogleSignIn() -> UIAction {
        return UIAction { _ in
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            // Start the google sign in flow!
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
                guard error == nil,
                      let user = result?.user,
                      let idToken = user.idToken?.tokenString
                else { return }
    
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

                Auth.auth().signIn(with: credential) { result, error in
                  // At this point, our user is signed in
                    print("Signed in: \(result)")
                }
            }
        }
    }
}
