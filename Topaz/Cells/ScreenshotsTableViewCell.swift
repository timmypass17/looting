//
//  ScreenshotsView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/28/24.
//

import Foundation

class ScreenshotsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ScreenshotsTableViewCell"
        
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
//        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .secondaryLabel
        return pageControl
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        
        pageControl.addAction(didTapPageControl(), for: .valueChanged)
        
        scrollView.delegate = self
        
        scrollView.addSubview(stackView)
        addSubview(scrollView)
        addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
                
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
//            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor)
            bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 1)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(screenshots: [Screenshot]) async {
        pageControl.numberOfPages = screenshots.count

        // Creates a task group, allowing you to add multiple tasks that can run concurrently.
        var screenshotViews: [ScreenshotView] = []
        for screenshot in screenshots {
            let view = ScreenshotView()
            view.imageView.heightAnchor.constraint(equalToConstant: (337 / 600) * self.frame.size.width).isActive = true
            view.imageView.widthAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
            screenshotViews.append(view)
            stackView.addArrangedSubview(view)
        }
        
        await withThrowingTaskGroup(of: Void.self) { group in
            for screenshot in screenshots {
                let view = screenshotViews[screenshot.id]
                group.addTask {
                    try Task.checkCancellation()
                    await view.update(imageURL: screenshot.thumbnailURL)
                }
            }
        }
    }
    
    func didTapPageControl() -> UIAction {
        return UIAction { [self] _ in
            let pageWidth = scrollView.frame.size.width
            let offsetX = CGFloat(pageControl.currentPage) * pageWidth
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
}

extension ScreenshotsTableViewCell: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = scrollView.contentOffset.x / pageWidth
        
        var newPage: Int
        
        if velocity.x == 0 { // slow scroll, settle on nearest page
            newPage = Int(round(currentPage))
        } else { // fast scroll, add or subtract one page
            newPage = velocity.x > 0 ? Int(ceil(currentPage)) : Int(floor(currentPage))
        }
        
        // Ensure new page doesn't exceed the number of pages
        newPage = max(0, min(newPage, pageControl.numberOfPages - 1))
        
        // Update the page control
        pageControl.currentPage = newPage
        
        // Update the target content offset so that the scroll view settles on the correct page
        let offsetX = CGFloat(newPage) * pageWidth
        targetContentOffset.pointee = CGPoint(x: offsetX, y: targetContentOffset.pointee.y)
    }
}
