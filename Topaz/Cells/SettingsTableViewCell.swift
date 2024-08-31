//
//  SettingsTableViewCell.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/16/24.
//

import Foundation
import UIKit


class SettingsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SettingsTableViewCell"
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Set image width & height
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 22),
            imageView.heightAnchor.constraint(equalToConstant: 22)
        ])
        return imageView
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        iconContainer.addSubview(iconImageView)
        container.addArrangedSubview(iconContainer)
        container.addArrangedSubview(label)
        
        contentView.addSubview(container)
                
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: iconContainer.topAnchor, constant: 4),
            iconImageView.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: -4),
            iconImageView.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor, constant: 4),
            iconImageView.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: -4)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: SettingsViewController.Item) {
        iconImageView.image = item.settings!.image
        iconContainer.backgroundColor = item.settings!.backgroundColor
        label.text = item.settings!.text
    }
}

class SettingsSelectionTableViewCell: SettingsTableViewCell {
    static let selectionReuseIdentifier = "SettingsSelectionTableViewCell"

    var secondaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        container.addArrangedSubview(secondaryLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(item: SettingsViewController.Item) {
        super.update(item: item)
        secondaryLabel.text = item.settings!.secondary
    }
}

class SettingsToggleTableViewCell: SettingsTableViewCell {
    static let toggleReuseIdentifier = "SettingsToggleTableViewCell"

    var toggleView = UISwitch()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        toggleView.addAction(toggleValueChanged(), for: .valueChanged)

        container.addArrangedSubview(toggleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(item: SettingsViewController.Item) {
        super.update(item: item)
        toggleView.isOn = Settings.shared.showExpiration
    }
    
    func toggleValueChanged() -> UIAction {
        return UIAction { [self] _ in
            Settings.shared.showExpiration = toggleView.isOn
            NotificationCenter.default.post(name: .showExpirationUpdated, object: nil)
        }
    }
}

