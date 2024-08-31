//
//  TagView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/14/24.
//

import UIKit

class GiveawayTypeTag: TagView {
    func update(type: GiveawayType) {
        tagLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        switch type {
        case .game:
            tagLabel.text = "Game"
            backgroundColor = .accent.withAlphaComponent(0.25)
            tagLabel.textColor = .accent
        case .dlc:
            tagLabel.text = "Loot"
            backgroundColor = .systemPurple.withAlphaComponent(0.25)
            tagLabel.textColor = .systemPurple
        case .earlyAccess:
            tagLabel.text = "Early Access"
            backgroundColor = .red.withAlphaComponent(0.25)
            tagLabel.textColor = .red
        case .other:
            tagLabel.text = "Other"
            backgroundColor = .systemGray.withAlphaComponent(0.25)
            tagLabel.textColor = .systemGray
        }
    }
}

class TimeRemainingTag: TagView {
    func update(endDate: Date?, dateType: DateType) {
        guard let endDate,
              .now < endDate,
              Settings.shared.showExpiration
        else {
            isHidden = true
            return
        }
        
        isHidden = false
        let dateDiffParts = Calendar.current.dateComponents([.day, .hour, .minute], from: .now, to: endDate)
        if let daysLeft = dateDiffParts.day, daysLeft > 0 {
            tagLabel.text = "\(daysLeft) \(dateType.daysString())"
        } else if let hoursLeft = dateDiffParts.hour, hoursLeft > 0 {
            tagLabel.text = "\(hoursLeft) \(dateType.hoursString())"
        } else if let minutesLeft = dateDiffParts.minute, minutesLeft > 0 {
            tagLabel.text = "\(minutesLeft) \(dateType.minutesString())"
        }
        
        backgroundColor = .black.withAlphaComponent(0.75)
        
        container.insertArrangedSubview(imageView, at: 0)   // doesn nothing if already inserted
        container.setCustomSpacing(4, after: imageView)
    }
    
    enum DateType {
        case normal, short, abbrev
        
        func daysString() -> String {
            switch self {
            case .normal:
                return "days"
            case .short:
                return "days"
            case .abbrev:
                return "d"
            }
        }
        
        func hoursString() -> String {
            switch self {
            case .normal:
                return "hours"
            case .short:
                return "hrs"
            case .abbrev:
                return "h"
            }
        }
        
        func minutesString() -> String {
            switch self {
            case .normal:
                return "mins"
            case .short:
                return "mins"
            case .abbrev:
                return "mins"
            }
        }
    }
}

class TagView: UIView {

    let tagLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant:15),
            imageView.widthAnchor.constraint(equalToConstant: 15)
        ])
        return imageView
    }()
    
    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
        container.addArrangedSubview(tagLabel)
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
