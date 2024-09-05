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
import AuthenticationServices

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
        case deleteAccount
        
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
        let image: UIImage
        var text: String
        var secondary: String?
        let backgroundColor: UIColor?
        
        init(image: UIImage, text: String, secondary: String? = nil, backgroundColor: UIColor?) {
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
            title: nil,
            data: [
                Item.settings(Model(image: UIImage(systemName: "globe")!, text: "Acknowledgements", backgroundColor: .systemBlue)),
                Item.settings(Model(image: UIImage(systemName: "hand.raised.fill")!, text: "Privacy Policy", backgroundColor: .systemGray))
            ]
        ),
        Section(
            data: [
                Item.signInOut
            ]
        ),
        Section(
            data: [
                Item.deleteAccount
            ]
        )
    ]
    
    var weeklySaleNotificationIndexPath = IndexPath(row: 0, section: 0)
    var showExpirationIndexPath = IndexPath(row: 1, section: 0)
    var contactIndexPath = IndexPath(row: 0, section: 1)
    var bugIndexPath = IndexPath(row: 1, section: 1)
    var acknowledgementsIndexPath = IndexPath(row: 0, section: 2)
    var privacyIndexPath = IndexPath(row: 1, section: 2)
    var signInOutIndexPath = IndexPath(row: 0, section: 3)
    var deleteAccountIndexPath = IndexPath(row: 0, section: 4)

        
    var appleAuthCrendentials: AuthCredential? = nil
    
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
            tableView.reloadSections(IndexSet([signInOutIndexPath, deleteAccountIndexPath].map { $0.section }), with: .automatic)
        }
    }
    
    
    func didTapSignInOutButton() {
        let isLoggedIn = Auth.auth().currentUser != nil
        if isLoggedIn {
            let title = "Sign Out?"
            let message = "Are you sure you want to sign out?"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { [self] _ in
                do {
                    try Auth.auth().signOut()
                    print("User signed out")
                } catch{
                    print("Error signing out: \(error)")
                }
                tableView.reloadSections(IndexSet(integer: signInOutIndexPath.section), with: .automatic)
            })
            alert.addAction(UIAlertAction(title: "Nevermind", style: .default))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        } else {
            Task {
                await startSignInWithGoogleFlow(self)
            }
        }
    }
    
    func didTapDeleteAccountButton() {
        let title = "Delete Account?"
        let message = "Are you sure you want to delete your account? This action is permanent and will remove all your wishlist items. You may need to re-login to proceed with this security-sensitive operation. This cannot be undone."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete Account", style: .destructive) { [self] _ in
            Task {
                await deleteUser()
            }
        })
        alert.addAction(UIAlertAction(title: "Nevermind", style: .default))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func deleteUser() async {
        // Note: Doesn't delete user's data. Deleting document does not delete subcollection. (Used Firebase Cloud Functions)
        guard let user = Auth.auth().currentUser else { return }

        do {
            try await user.delete()
            print("Deleted user successfully")
        }
        catch {
            // Deleting account requires user to sign in recently, re-authenticate the user to perform security sensitive actions
            print("Error deleting account: \(error)")
            if let user = Auth.auth().currentUser {
                // Figure out which auth provider the user used to log in
                let providerID = user.providerData[0].providerID
                if providerID == "google.com" {
                    let result: AuthDataResult? = await startSignInWithGoogleFlow(self)
                    await deleteUser()
                } else if providerID == "apple.com" {
                    startSignInWithAppleFlow(self)
                }
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
        
        if indexPath == signInOutIndexPath {
            // Sign Out
            let cell = tableView.dequeueReusableCell(withIdentifier: SignOutTableViewCell.reuseIdentifier, for: indexPath) as! SignOutTableViewCell
            let isLoggedIn = Auth.auth().currentUser != nil
            cell.label.text = "Sign Out"
            cell.label.textColor = .red
            cell.label.isEnabled = isLoggedIn
            cell.selectionStyle = isLoggedIn ? .default : .none
            return cell
        }
        
        if indexPath == deleteAccountIndexPath {
            // Sign Out
            let cell = tableView.dequeueReusableCell(withIdentifier: SignOutTableViewCell.reuseIdentifier, for: indexPath) as! SignOutTableViewCell
            let isLoggedIn = Auth.auth().currentUser != nil
            cell.label.text = "Delete Account"
            cell.label.textColor = .red
            cell.label.isEnabled = isLoggedIn
            cell.selectionStyle = isLoggedIn ? .default : .none
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
        } else if indexPath == acknowledgementsIndexPath {
            let acknowledgementsViewController = AcknowledgementsViewController()
            navigationController?.pushViewController(acknowledgementsViewController, animated: true)
        } else if indexPath == privacyIndexPath {
            let privacyViewController = PrivacyViewController()
            navigationController?.pushViewController(privacyViewController, animated: true)
        } else if indexPath == signInOutIndexPath {
            didTapSignInOutButton()
        } else if indexPath == deleteAccountIndexPath {
            didTapDeleteAccountButton()
        }
    }
    
    // Disable selection (does not remove highlight, use cell.selectionStyle = .none)
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath == showExpirationIndexPath {
            return nil
        }
        
        if indexPath == signInOutIndexPath || indexPath == deleteAccountIndexPath {
            let isLoggedIn = Auth.auth().currentUser != nil
            if isLoggedIn {
                return indexPath
            } else {
                return nil
            }
        }
        
        return indexPath
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Get notified every Friday (19:00 UTC) for games on sale in your wishlist."
        }
        
        return nil
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

extension SettingsViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = Settings.shared.nonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            
            // Sign in with Firebase
            Task {
                do {
                    let result = try await Auth.auth().signIn(with: credential)
                    await deleteUser()
                } catch {
                    print("Error signing with in Apple: \(error)")
                    appleAuthCrendentials = nil
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension SettingsViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
