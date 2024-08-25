//
//  ShopsViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/21/24.
//

import UIKit

class ShopsViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Shop>!
    let service = IsThereAnyDealService()
    
    enum Section: Hashable {
        case shops
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shops"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.delegate = self
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // MARK: Register cells
        collectionView.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: StoreCollectionViewCell.reuseIdentifier)

        // MARK: Collection View Setup
        collectionView.collectionViewLayout = createLayout()

        configureDataSource()
        
        Task {
            await loadShops()
        }
    }
    
    private func loadShops() async {
        let shops = await getShops()
        var snapshot = NSDiffableDataSourceSnapshot<Section, Shop>()
        snapshot.appendSections([.shops])
        snapshot.appendItems(shops)
        await dataSource.apply(snapshot)
    }
    
    private func getShops() async -> [Shop] {
        do {
            let shops = try await service.getShops()
                .sorted { $0.deals > $1.deals }
            return shops
        } catch {
            return []
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // MARK: Categories Section Layout
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(44)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.reuseIdentifier, for: indexPath) as! StoreCollectionViewCell
            let isLastItem = collectionView.numberOfItems(inSection: indexPath.section) == indexPath.row + 1
            cell.update(with: itemIdentifier, hideBottomLine: isLastItem)
            return cell
        }
    }
}

extension ShopsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let shop = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let detailListViewController = DetailListViewController()
        detailListViewController.title = shop.title
        detailListViewController.section = .shops
        detailListViewController.shopID = shop.id
        navigationController?.pushViewController(detailListViewController, animated: true)
    }
}
