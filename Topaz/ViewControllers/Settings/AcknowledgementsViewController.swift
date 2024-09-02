//
//  AcknowledgementsViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 9/1/24.
//

import UIKit
import SafariServices

class AcknowledgementsViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case credit
        case isThereAnyDeal
        case gamerPower
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let cellReuseIdentifier = "AcknowledgementsCell"
    let isThereAnyDealIndexPath = IndexPath(row: 0, section: 1)
    let gamerPowerIndexPath = IndexPath(row: 0, section: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        navigationItem.title = "Acknowledgements"
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension AcknowledgementsViewController: UITableViewDataSource {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .credit:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = "Thank you for IsThereAnyDeal and GamerPower for providing the latest information about game deals and live giveaways. Please visit their websites below for more awesome gaming content!"
            cell.contentConfiguration = config
            return cell
        case .isThereAnyDeal:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = "IsThereAnyDeal"
            config.textProperties.color = .link
            cell.contentConfiguration = config
            return cell
        case .gamerPower:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = "GamerPower"
            config.textProperties.color = .link
            cell.contentConfiguration = config
            return cell
        }
    }
}

extension AcknowledgementsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == isThereAnyDealIndexPath {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: URL(string: "https://isthereanydeal.com/")!, configuration: config)
            present(vc, animated: true)
        } else if indexPath == gamerPowerIndexPath {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: URL(string: "https://www.gamerpower.com/")!, configuration: config)
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == Section.credit.rawValue {
            return nil
        }
        
        return indexPath
    }
}
