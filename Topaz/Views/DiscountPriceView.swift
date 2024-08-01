//
//  DiscountPriceView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/27/24.
//

import UIKit

class DiscountPriceView: UIView {
    let priceView = PriceView()
    let discountView = DiscountView()
    
    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        container.addArrangedSubview(discountView)
        container.addArrangedSubview(priceView)
        
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(regular: Double, amount: Double, cut: Int) {
        priceView.update(current: amount, regular: regular)
        discountView.update(cut: cut)
    }
}

//#Preview {
//    let view = DiscountPriceView()
//    view.priceView.regularLabel.text = "$59.99"
//    view.priceView.saleLabel.text = "$32.99"
//    view.discountView.discountLabel.text = "-%45"
//    return view
//}
