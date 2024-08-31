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
import MessageUI

class SettingsViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let email = "timmysappstuff@gmail.com"
    
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
                Item.settings(Model(image: UIImage(systemName: "bell.fill")!, text: "Weekly Sale Notification", backgroundColor: .accent)),
                Item.settings(Model(image: UIImage(systemName: "clock.fill")!, text: "Show Expiration", backgroundColor: .accent)),
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
    
    var weeklySaleNotificationIndexPath = IndexPath(row: 0, section: 0)
    var showExpirationIndexPath = IndexPath(row: 1, section: 0)
    var contactIndexPath = IndexPath(row: 0, section: 1)
    var bugIndexPath = IndexPath(row: 1, section: 1)
    var privacyIndexPath = IndexPath(row: 0, section: 2)
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
        tableView.register(SettingsSelectionTableViewCell.self, forCellReuseIdentifier: SettingsSelectionTableViewCell.selectionReuseIdentifier)
        tableView.register(SettingsToggleTableViewCell.self, forCellReuseIdentifier: SettingsToggleTableViewCell.toggleReuseIdentifier)

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
        
        if indexPath == showExpirationIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsToggleTableViewCell.toggleReuseIdentifier, for: indexPath) as! SettingsToggleTableViewCell
            let model = sections[indexPath.section].data[indexPath.row]
            cell.update(item: model)
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier, for: indexPath) as! SettingsTableViewCell
        let model = sections[indexPath.section].data[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.update(item: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == weeklySaleNotificationIndexPath {
            navigationController?.pushViewController(NotificationTableViewController(), animated: true)
        } else if indexPath == contactIndexPath {
            guard MFMailComposeViewController.canSendMail() else {
                showMailErrorAlert()
                return
            }
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients([email])
            mailComposer.setSubject("[BuiltDiff] Contact Us")
            
            present(mailComposer, animated: true)
        } else if indexPath == bugIndexPath {
            guard MFMailComposeViewController.canSendMail() else {
                showMailErrorAlert()
                return
            }
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setToRecipients([email])
            mailComposer.setSubject("[BuiltDiff] Bug Report")
            
            present(mailComposer, animated: true)
        } else if indexPath == signInOutIndexPath {
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
        } else if indexPath == privacyIndexPath {
            let privacyViewController = PrivacyViewController()
            navigationController?.pushViewController(privacyViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath == showExpirationIndexPath {
            return nil
        }
        
        return indexPath
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func showMailErrorAlert() {
        let alert = UIAlertController(
            title: "No Email Account Found",
            message: "There is no email account associated to this device. If you have any questions, please feel free to reach out to us at \(email)",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
        self.present(alert, animated: true, completion: nil)
    }
}
