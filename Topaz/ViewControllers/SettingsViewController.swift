//
//  SettingsViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class SettingsViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    enum Item {
        case signIn
        case settings(Model)
        case signOut
        
        var settings: Model? {
            if case .settings(let model) = self {
                return model
            } else {
                return nil
            }
        }
    }
    
    struct Section {
        var title: String?
        var data: [Item]
    }
    
    struct Model {
        let image: UIImage?
        var text: String
        var secondary: String?
        let backgroundColor: UIColor?
        
        init(image: UIImage?, text: String, secondary: String? = nil, backgroundColor: UIColor?) {
            self.image = image
            self.text = text
            self.secondary = secondary
            self.backgroundColor = backgroundColor
        }
    }
    
    var sections: [Section] = [
        Section(title: "User", data: [Item.settings(Model(image: UIImage(systemName: "person")!, text: "N/A", secondary: "", backgroundColor: .accent))]),
        Section(title: "Help & Support",
                data: [Item.settings(Model(image: UIImage(systemName: "mail.fill")!, text: "Contact Us", backgroundColor: .systemGreen)),
                       Item.settings(Model(image: UIImage(systemName: "ladybug.fill")!, text: "Bug Report", backgroundColor: .systemRed))]),
        Section(title: "Privacy",
                data: [Item.settings(Model(image: UIImage(systemName: "hand.raised.fill")!, text: "Privacy Policy", backgroundColor: .systemGray))]),
        Section(data: [Item.signOut])
    ]
    

    var signoutIndexPath: IndexPath {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.data.firstIndex(where: { item in
                if case .signOut = item {
                    return true
                }
                return false
            }) {
                return IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        
        fatalError("signOut item not found in sections")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
        tableView.register(SignInTableViewCell.self, forCellReuseIdentifier: SignInTableViewCell.reuseIdentifier)
        tableView.register(SignOutTableViewCell.self, forCellReuseIdentifier: SignOutTableViewCell.reuseIdentifier)

        let headerView = GoogleSignInHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 48))
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        Auth.auth().addStateDidChangeListener { [self] auth, user in
            if let user {
                print("Got user: \(user.displayName)")
            } else {
                print("User not logged in")
            }
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath == signoutIndexPath {
            // Sign Out
            let cell = tableView.dequeueReusableCell(withIdentifier: SignOutTableViewCell.reuseIdentifier, for: indexPath) as! SignOutTableViewCell
            if Auth.auth().currentUser != nil{
                cell.label.isEnabled = true
            } else {
                cell.label.isEnabled = false
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier, for: indexPath) as! SettingsTableViewCell
        let model = sections[indexPath.section].data[indexPath.row]
        cell.update(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let isLoggedIn = Auth.auth().currentUser != nil
        if !isLoggedIn && indexPath == signoutIndexPath {
            return nil
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == signoutIndexPath {
            do {
                try Auth.auth().signOut()
                print("User signed out")
            } catch{
                print("Error signing out: \(error)")
            }
            tableView.reloadSections(IndexSet(integer: signoutIndexPath.section), with: .automatic)
        }
    }
    
    
}

extension SettingsViewController: GoogleSignInHeaderViewDelegate {
    func googleSignInHeaderViewDelegate(_ sender: GoogleSignInHeaderView, didTapSignIn: Bool) {
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
