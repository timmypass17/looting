//
//  GiveawayViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import UIKit
import SafariServices

class GiveawayViewController: UIViewController {

    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    let searchController = UISearchController()

    var dataSource: UICollectionViewDiffableDataSource<Section, Giveaway>!
    var original: [Giveaway] = []
    
    enum Section: Hashable {
        case giveaway
    }
    
    let service = GamerPowerService()
    var imageTasks: [IndexPath: Task<Void, Never>] = [:]
    
    var selectedSearchScope: SearchScope {
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        let searchScope = SearchScope.allCases[selectedIndex]
        
        return searchScope
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Live Giveaways"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = SearchScope.allCases.map { $0.title }
        searchController.searchBar.placeholder = "Filter by title"
        
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // MARK: Register cells/supplmentary views
        collectionView.register(GiveawayCollectionViewCell.self, forCellWithReuseIdentifier: GiveawayCollectionViewCell.reuseIdentifier)

        // MARK: Collection View Setup
        collectionView.collectionViewLayout = createLayout()

        configureDataSource() // provides cell
        
        Task {
            do {
                let giveaways: [Giveaway] = try await service.getGiveaways()
                original = giveaways
                updateSnapshot(with: giveaways)
            } catch {
                print("Error fetching giveaway: \(error)")
            }
        }
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

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .absolute(200)
            ),
            repeatingSubitem: item,
            count: 2
        )

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiveawayCollectionViewCell.reuseIdentifier, for: indexPath) as! GiveawayCollectionViewCell
            self.imageTasks[indexPath]?.cancel()
            self.imageTasks[indexPath] = Task {
                await cell.update(with: itemIdentifier)
                self.imageTasks[indexPath] = nil
            }
            return cell
        }
    }
    
    private func updateSnapshot(with items: [Giveaway]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Giveaway>()
        snapshot.appendSections([.giveaway])
        snapshot.appendItems(items, toSection: .giveaway)
        dataSource.apply(snapshot)
    }
    
}

extension GiveawayViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        var filteredItems: [Giveaway] = original.filter {
            selectedSearchScope.type == $0.type || selectedSearchScope == .all
        }
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredItems = filteredItems.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
        
        updateSnapshot(with: filteredItems)
    }
}

extension GiveawayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true

        let vc = SFSafariViewController(url: URL(string: item.giveawayUrl)!, configuration: config)
        present(vc, animated: true)
    }
}
