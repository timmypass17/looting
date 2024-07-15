//
//  WishlistViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import UIKit
import CommonCrypto
import SafariServices

class WishlistViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let codeVerifier = generateCodeVerifier()
        let codeChallenge = createCodeChallenge(from: codeVerifier)
//        storeCodeVerifierInCookie(codeVerifier)

        print("Code Verifier: \(codeVerifier)")
        print("Code Challenge: \(codeChallenge)")
        
        if let authorizationURL = buildAuthorizationURL(codeVerifier: codeVerifier) {
            present(SFSafariViewController(url: authorizationURL), animated: true)

//            UIApplication.shared.open(authorizationURL)
        }
    }

    
    // The code verifier is a cryptographically random string using the characters A-Z, a-z, 0-9, and the punctuation characters -._~ (hyphen, period, underscore, and tilde), between 43 and 128 characters long
    func generateCodeVerifier() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let length = Int.random(in: 43...128)
        var codeVerifier = ""
        
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let index = characters.index(characters.startIndex, offsetBy: randomIndex)
            codeVerifier.append(characters[index])
        }
        
        return codeVerifier
    }

    // Once the client has generated the code verifier, it uses that to create the code challenge
    func createCodeChallenge(from codeVerifier: String) -> String {
        // Convert the code verifier to a SHA-256 hash.
        // Convert the SHA-256 hash to a Base64-URL-encoded string.
        return base64url(sha256(codeVerifier))
    }

    func sha256(_ input: String) -> Data {
        let inputData = Data(input.utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        inputData.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(inputData.count), &hash)
        }
        return Data(hash)
    }

    func base64url(_ data: Data) -> String {
        var base64 = data.base64EncodedString()
        base64 = base64.replacingOccurrences(of: "+", with: "-")
        base64 = base64.replacingOccurrences(of: "/", with: "_")
        base64 = base64.replacingOccurrences(of: "=", with: "")
        return base64
    }

    
    func buildAuthorizationURL(codeVerifier: String) -> URL? {
        let authorizationBaseURLString = "https://isthereanydeal.com/oauth/authorize/"
        
        var components = URLComponents(string: authorizationBaseURLString)
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: "9247d05e4863edf2"),
            URLQueryItem(name: "redirect_uri", value: "https://timmyTopaz://auth"),  // url to get back to app
            URLQueryItem(name: "scope", value: "wait_read"),
            URLQueryItem(name: "state", value: generateStateParameter()),
            URLQueryItem(name: "code_challenge", value: codeVerifier),
            URLQueryItem(name: "code_challenge_method", value: "S256")
        ]
        
        let authorizationURL = components?.url
        return authorizationURL
    }
    
    func generateStateParameter() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        let length = 16 // A typical length for the state parameter
        var state = ""
        
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let index = characters.index(characters.startIndex, offsetBy: randomIndex)
            state.append(characters[index])
        }
        
        return state
    }
}

// No, the redirect URI does not have to start with https://. When dealing with custom URL schemes like timmyTopaz://auth, you do not use https:// because you're not redirecting to a web URL but rather to a custom scheme registered by your iOS app.
