//
//  SectionHeaderView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/24/24.
//

import UIKit

protocol SectionHeaderViewDelegate: AnyObject {
    func sectionHeaderView(_ sender: SectionHeaderView, didTapSeeAllButton: Bool)
}

class SectionHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "SectionHeaderView"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    let seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("See All", for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    weak var delegate: SectionHeaderViewDelegate?
    var section: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        ])
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(seeAllButton)
        
        seeAllButton.addAction(didTapSeeAllButton(), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        label.text = title
    }
    
    func didTapSeeAllButton() -> UIAction {
        return UIAction { _ in
            self.delegate?.sectionHeaderView(self, didTapSeeAllButton: true)
        }
    }
}
