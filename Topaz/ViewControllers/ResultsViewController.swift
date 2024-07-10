//
//  SearchViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/27/24.
//

import UIKit

protocol ResultsViewControllerDelegate: AnyObject {
    func resultsViewController(_ viewController: ResultsViewController, didSelectItem item: Item)
}

class ResultsViewController: UIViewController {
    
    var originalResults: [Item] = []
    
    enum Section: Hashable {
        case results
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()) // dummy
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    var sections = [Section]()
    var imageTasks: [IndexPath: Task<Void, Never>] = [:]
    
    weak var delegate: ResultsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag

        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.register(DealSmallCollectionViewCell.self, forCellWithReuseIdentifier: DealSmallCollectionViewCell.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
        configureDataSource() // provides cell

    }
    
    func createLayout() -> UICollectionViewLayout {
        // MARK: Standard Section Layout
        let item = NSCollectionLayoutItem(
            layoutSize:
                NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
        )

        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)
            ),
            repeatingSubitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 20, trailing: 0)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DealSmallCollectionViewCell.reuseIdentifier, for: indexPath) as! DealSmallCollectionViewCell
            self.imageTasks[indexPath]?.cancel()
            self.imageTasks[indexPath] = Task {
                await cell.update(with: itemIdentifier.game!, itemIdentifier.dealItem!)
                self.imageTasks[indexPath] = nil
            }
            return cell
        }
    }
    
}

extension ResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        delegate?.resultsViewController(self, didSelectItem: item)
    }
}
