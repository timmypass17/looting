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
        case settings(Model)
        case signInOut
        
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
        Section(
            title: "General",
            data: [
                Item.settings(Model(image: UIImage(systemName: "bell.fill")!, text: "Weekly Sale Notification", secondary: "", backgroundColor: .accent)),
                Item.settings(Model(image: UIImage(systemName: "clock.fill")!, text: "Show Expiration", secondary: "", backgroundColor: .accent)),
            ]
        ),
        Section(
            title: "Help & Support",
            data: [
                Item.settings(Model(image: UIImage(systemName: "mail.fill")!, text: "Contact Us", backgroundColor: .systemGreen)),
                Item.settings(Model(image: UIImage(systemName: "ladybug.fill")!, text: "Bug Report", backgroundColor: .systemRed))
            ]
        ),
        Section(
            title: "Privacy",
            data: [
                Item.settings(Model(image: UIImage(systemName: "hand.raised.fill")!, text: "Privacy Policy", backgroundColor: .systemGray))
            ]
        ),
        Section(
            data: [
                Item.signInOut
            ]
        )
    ]
    

    var signInOutIndexPath = IndexPath(row: 0, section: 3)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
        tableView.register(SignInTableViewCell.self, forCellReuseIdentifier: SignInTableViewCell.reuseIdentifier)
        tableView.register(SignOutTableViewCell.self, forCellReuseIdentifier: SignOutTableViewCell.reuseIdentifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Gets called whenever user logs in or out
        Auth.auth().addStateDidChangeListener { [self] auth, user in
            tableView.reloadSections(IndexSet(integer: signInOutIndexPath.section), with: .automatic)
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
        
        if indexPath == signInOutIndexPath {
            // Sign Out
            let cell = tableView.dequeueReusableCell(withIdentifier: SignOutTableViewCell.reuseIdentifier, for: indexPath) as! SignOutTableViewCell
            let isLoggedIn = Auth.auth().currentUser != nil
            if isLoggedIn {
                cell.label.text = "Sign Out"
                cell.label.textColor = .red
            } else {
                cell.label.text = "Sign In with Google"
                cell.label.textColor = .link
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == signInOutIndexPath {
            let isLoggedIn = Auth.auth().currentUser != nil
            if isLoggedIn {
                do {
                    try Auth.auth().signOut()
                    print("User signed out")
                } catch{
                    print("Error signing out: \(error)")
                }
                tableView.reloadSections(IndexSet(integer: signInOutIndexPath.section), with: .automatic)
            } else {
                Task {
                    await showGoogleSignIn(self)
                }
            }
        }
    }
}
