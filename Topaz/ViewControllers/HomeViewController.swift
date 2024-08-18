//
//  ViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import UIKit

// TODO: Add discount percent to banner (ex. -%50) with white text black bg or steam but orange
// TODO: Game deals aren't using lowest deal
class HomeViewController: UIViewController {

//    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
    var searchController: UISearchController!
    private var resultsViewController: ResultsViewController!

    enum Section: Hashable {
        case featured
        case medium(String)
        case standard(String)
        case shops
    }

    enum SupplementaryViewKind {
        static let header = "header"
        static let topLine = "topLine"
        static let bottomLine = "bottomLine"
    }

    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()) // dummy
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var sections = [Section]()
    let service = IsThereAnyDealService()
    
    var loadGameTasks: Task <Void, Never>? = nil
    var searchTask: Task<Void, Never>? = nil
    var imageTasks: [IndexPath: Task<Void, Never>] = [:]
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Game Deals"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.delegate = self

        resultsViewController = ResultsViewController()
        resultsViewController.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Games By Title"
        searchController.showsSearchResultsController = true // Always show the search result controller even when search is empty
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        resultsViewController.loadViewIfNeeded()    // make sure viewDidLoad() is called so datasource is initalized
        
//        collectionView.refreshControl = UIRefreshControl()
//        collectionView.refreshControl?.addAction(didSwipeToRefresh(), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), primaryAction: nil, menu: nil)

        setupCollectionView()
        
        loadGameTasks = Task {
            do {
                try await fetchAndLoadGames()
            } catch {
                print("Error loading game tasks")
            }
        }
        
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // MARK: Register cells/supplmentary views
        collectionView.register(FeaturedDealCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedDealCollectionViewCell.reuseIdentifier)
        collectionView.register(DealMediumCollectionViewCell.self, forCellWithReuseIdentifier: DealMediumCollectionViewCell.reuseIdentifier)
        collectionView.register(DealSmallCollectionViewCell.self, forCellWithReuseIdentifier: DealSmallCollectionViewCell.reuseIdentifier)
        collectionView.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: StoreCollectionViewCell.reuseIdentifier)

        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.topLine, withReuseIdentifier: LineView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.bottomLine, withReuseIdentifier: LineView.reuseIdentifier)

        // MARK: Collection View Setup
        collectionView.collectionViewLayout = createLayout()

        configureDataSource() // provides cell
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            // Header
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .estimated(44)
                ),
                elementKind: SupplementaryViewKind.header,
                alignment: .top
            )
            headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)

            // Line (not lines between cells)
            let lineItemHeight = 1 / layoutEnvironment.traitCollection.displayScale // single pixel
            let lineItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.92),
                heightDimension: .absolute(lineItemHeight)
            )

            let topLineItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: lineItemSize,
                elementKind: SupplementaryViewKind.topLine,
                alignment: .top
            )

            let bottomLineItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: lineItemSize,
                elementKind: SupplementaryViewKind.bottomLine,
                alignment: .bottom
            )

            let supplementaryItemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
            headerItem.contentInsets = supplementaryItemContentInsets
            topLineItem.contentInsets = supplementaryItemContentInsets
            bottomLineItem.contentInsets = supplementaryItemContentInsets

            let section = self.sections[sectionIndex]
            switch section {
            case .featured:
                // MARK: Promoted Section Layout
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(300))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered // horizontal scrolling
                section.boundarySupplementaryItems = [topLineItem, bottomLineItem]

                // padding between top and bottom lines
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 20, trailing: 0)

                return section
            case .medium:
                // Note: We had to set different header/footer (bottom line) because we not centering automatically using .groupPagingCentered
                let item = NSCollectionLayoutItem(
                    layoutSize:
                        NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalHeight(1)
                        )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1/3),
                        heightDimension: .absolute(300)), // 300
                    repeatingSubitem: item,
                    count: 1
                )
                
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1), // diff, was .92
                        heightDimension: .estimated(44)
                    ),
                    elementKind: SupplementaryViewKind.header,
                    alignment: .top
                )
                headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let lineItemHeight = 1 / layoutEnvironment.traitCollection.displayScale
                let lineItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1), // diff, was .92
                    heightDimension: .absolute(lineItemHeight)
                )

                let bottomLineItem = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: lineItemSize,
                    elementKind: SupplementaryViewKind.bottomLine,
                    alignment: .bottom
                )
                
                section.boundarySupplementaryItems = [headerItem, bottomLineItem]
                
                let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width
                let groupWidth = availableLayoutWidth * 0.92
                let remainingWidth = availableLayoutWidth - groupWidth
                let halfOfRemainingWidth = remainingWidth / 2.0
                let itemLeadingAndTrailingInset = halfOfRemainingWidth

                // effects headers/footer too
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: itemLeadingAndTrailingInset, bottom: 20, trailing: itemLeadingAndTrailingInset)
                
                return section
            case .standard:
                // MARK: Standard Section Layout
                let item = NSCollectionLayoutItem(
                    layoutSize:
                        NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalHeight(1/4)
                        )
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)

                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.92),
                        heightDimension: .absolute(200)),
                    repeatingSubitem: item,
                    count: 4
                )

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.boundarySupplementaryItems = [headerItem, bottomLineItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 20, trailing: 0)

                return section

            case .shops:
                // MARK: Categories Section Layout
                let itemSize =  NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                // Because the category items should align with the centered groups above them, you'll need to dynamically calculate their insets (other cells dont need to cause they centered automatically using .groupPagingCentered)
                let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width
                let groupWidth = availableLayoutWidth * 0.92
                let remainingWidth = availableLayoutWidth - groupWidth
                let halfOfRemainingWidth = remainingWidth / 2.0
                let nonCategorySectionItemInset = CGFloat(4)
                let itemLeadingAndTrailingInset = halfOfRemainingWidth + nonCategorySectionItemInset

                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: itemLeadingAndTrailingInset,
                    bottom: 0,
                    trailing: itemLeadingAndTrailingInset
                )

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(44)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]

                return section
            }
        }

        return layout
    }

    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let section = self.sections[indexPath.section]
            switch section {
            case .featured:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedDealCollectionViewCell.reuseIdentifier, for: indexPath) as! FeaturedDealCollectionViewCell
                self.imageTasks[indexPath]?.cancel()
                self.imageTasks[indexPath] = Task {
                    await cell.update(with: itemIdentifier.game!, dealItem: itemIdentifier.dealItem!)
                    self.imageTasks[indexPath] = nil
                }
                
                return cell
            case .medium:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DealMediumCollectionViewCell.reuseIdentifier, for: indexPath) as! DealMediumCollectionViewCell
                cell.update(game: itemIdentifier.game!, dealItem: itemIdentifier.dealItem!)
                return cell
            case .standard:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DealSmallCollectionViewCell.reuseIdentifier, for: indexPath) as! DealSmallCollectionViewCell
                self.imageTasks[indexPath]?.cancel()
                self.imageTasks[indexPath] = Task {
                    let isFourthItem = (indexPath.row + 1).isMultiple(of: 4)
                    await cell.update(title: itemIdentifier.game!.title, imageURL: itemIdentifier.game!.assets?.banner400, deal: itemIdentifier.dealItem?.deal, hideBottomLine: isFourthItem)
                    self.imageTasks[indexPath] = nil
                }
                return cell
            case .shops:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.reuseIdentifier, for: indexPath) as! StoreCollectionViewCell
                let isLastItem = collectionView.numberOfItems(inSection: indexPath.section) == indexPath.row + 1
                cell.update(with: itemIdentifier.shop!, hideBottomLine: isLastItem)

                return cell
            }
        }

        // MARK: Supplementary View Provider
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.header:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView

                let section = self.sections[indexPath.section]
                let sectionName: String
                switch section {
                case .featured:
                    return nil
                case .medium(let name):
                    sectionName = name
                case .standard(let name):
                    sectionName = name
                case .shops:
                    sectionName = "Deals by Shop"
                }

                headerView.setTitle(sectionName)

                return headerView

            case SupplementaryViewKind.topLine, SupplementaryViewKind.bottomLine:
                let lineView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LineView.reuseIdentifier, for: indexPath) as! LineView
                return lineView

            default:
                return nil
            }
        }
    }

    func getGames(limit: Int = 20, shops: [Int] = []) async -> [Item] {
        do {
            var gameDealsMap: [String: (Game, DealItem)] = [:]
            let deals: [DealItem] = try await service.getDeals(limit: limit, shops: shops).list
            
            try await withThrowingTaskGroup(of: (Game, DealItem).self) { group in
                for deal in deals {
                    group.addTask {
                        try Task.checkCancellation()
                        let game = try await self.service.getGame(id: deal.id)
                        return (game, deal)
                    }
                }
                
                for try await (game, deal) in group {
                    gameDealsMap[game.id] = ((game, deal))
                }
            }
            
            var gameDeals: [(Game, DealItem)] = []
            // Sorted in order of deals
            for deal in deals {
                guard let result = gameDealsMap[deal.id] else { continue }
                gameDeals.append(result)
            }
            
            return gameDeals.map { Item.game($0, $1) }
        } catch {
            print("Failed to fetch games: \(error)")
            return []
        }
    }
    
    func getGames(title: String) async -> [Item] {
        do {
            let searchItems: [SearchItem] = try await service.getSearchItems(title: title)
            return await getGames(gameIDs: searchItems.map { $0.id })
        } catch {
            print("Error fetching \(title): \(error)")
            return []
        }
    }
    
    func getMostWaitlisted() async -> [Item] {
        do {
            let waitlist: [Stat] = try await self.service.getMostWaitlist()
            let games = await self.getGames(gameIDs: waitlist.map { $0.id })
            return games
        } catch {
            print("Error fetching waitlist: \(error)")
            return []
        }
    }
    
    func getMostPopular() async -> [Item] {
        do {
            let popular: [Stat] = try await self.service.getPopular()
            let games = await self.getGames(gameIDs: popular.map { $0.id })
            return games
        } catch {
            print("Error fetching waitlist: \(error)")
            return []
        }
    }
    
    private func getGames(gameIDs: [String]) async -> [Item] {
        do {
            var items: [Item] = []
            var gameMap: [String: Game] = [:]
            var prices: [Price] = []
            
            try await withThrowingTaskGroup(of: Game.self) { group in
                for id in gameIDs {
                    group.addTask {
                        try Task.checkCancellation()
                        let game = try await self.service.getGame(id: id)
                        return game
                    }
                }
                
                for try await game in group {
                    gameMap[game.id] = game
                }
            }
            
            prices = try await service.getPrices(gameIDs: gameMap.values.map { $0.id})
            
            for id in gameIDs {
                guard let game = gameMap[id],
                      let price = prices.first(where: { $0.id == id }),
                      let cheapestDeal = price.deals.min(by: { $0.price.amount < $1.price.amount })
                else { continue }
                let dealItem = DealItem(id: game.id, title: game.title, deal: cheapestDeal)
                items.append(Item.game(game, dealItem))
            }
            
            return items
        } catch {
            print("Error getting games: \(error)")
            return []
        }
    }

    func getShops() async -> [Item] {
        do {
            let shops = try await service.getShops()
                .sorted { $0.deals > $1.deals }
                .prefix(7)
            return shops.map { Item.shop($0) }
        } catch {
            return []
        }
    }
    
    // Fetches 3 apis request simulatenously
    // Managing all these tasks with a single searchTask variable and can cancel the whole TaskGroup with a single call.
    func fetchAndLoadGames() async throws {
        // Run tasks concurrently
        try await withThrowingTaskGroup(of: (Section, [Item]).self) { group in
            group.addTask {
                try Task.checkCancellation()
                let featuredGames = await self.getGames()
                
                return (Section.featured, featuredGames)
            }
            
            group.addTask {
                try Task.checkCancellation()
                return (Section.medium("Most Popular"), await self.getMostPopular())
            }
            
            group.addTask {
                try Task.checkCancellation()
                return (Section.medium("Most Waitlisted"), await self.getMostWaitlisted())
            }
            
            group.addTask {
                try Task.checkCancellation()
                let steamID = 61
                return (Section.standard("Steam"), await self.getGames(shops: [steamID]))
            }
            
            group.addTask {
                try Task.checkCancellation()
                let gogID = 35
                return (Section.standard("GOG"), await self.getGames(shops: [gogID]))
            }
            
            group.addTask {
                try Task.checkCancellation()
                return (Section.shops, await self.getShops())
            }
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

            snapshot.appendSections([
                .featured,
                .medium("Most Popular"),
                .medium("Most Waitlisted"),
                .standard("Steam"),
                .standard("GOG"),
                .shops
            ])
            
            sections = snapshot.sectionIdentifiers
            
            // Process items as we get them
            for try await (section, items) in group {
                try Task.checkCancellation()
    
                snapshot.appendItems(items, toSection: section)
                
                await dataSource.apply(snapshot, animatingDifferences: true)
                
                if section == .featured {
                    resultsViewController.originalResults = items
                    var resultSnapshot = NSDiffableDataSourceSnapshot<ResultsViewController.Section, Item>()
        
                    resultSnapshot.appendSections([.results])
                    resultSnapshot.appendItems(items, toSection: .results)
        
                    await resultsViewController.dataSource.apply(resultSnapshot)
                }
            }
        }
        
        // Do something after we collected all data
    }
    
    func handleSearchingGames(title: String) {
        searchTask?.cancel()
        searchTask = Task {
            let games = await getGames(title: title)
            var snapshot = NSDiffableDataSourceSnapshot<ResultsViewController.Section, Item>()
            snapshot.appendSections([.results])
            snapshot.appendItems(games, toSection: .results)
            await resultsViewController.dataSource.apply(snapshot)
            searchTask = nil
        }
    }
    
    private func showDetailView(game item: Item) {
        let detailViewController = GameDetailViewController(game: item.game!, dealItem: item.dealItem!)
        if let wishlistViewController = (tabBarController?.viewControllers?[2] as? UINavigationController)?.viewControllers[0] as? WishlistViewController {
            detailViewController.delegate = wishlistViewController
        }
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
//    func didSwipeToRefresh() -> UIAction {
//        return UIAction { [self] _ in
//            loadGameTasks?.cancel()
//            loadGameTasks = Task {
//                do {
//                    // When working with UICollectionViewDiffableDataSource, you update snapshot and apply changes to datasource
//                    collectionView.refreshControl?.beginRefreshing()
//                    await clearData()
//                    try await fetchAndLoadGames()
//                    collectionView.refreshControl?.endRefreshing()
//
//                } catch {
//                    print("Error loading game tasks")
//                }
//                loadGameTasks = nil
//            }
//        }
//    }
    
//    func clearData() async {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
//        await dataSource.apply(snapshot)
//    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let title = searchBar.text else { return }
        print("Searching for \(title)...")
        
        handleSearchingGames(title: title)
    }
}

extension HomeViewController: UISearchResultsUpdating {
    // Called when search bar is selected or searchbar text changes
    func updateSearchResults(for searchController: UISearchController) {
        guard let title = searchController.searchBar.text else { return }

        if title.isEmpty {
            var snapshot = NSDiffableDataSourceSnapshot<ResultsViewController.Section, Item>()
            snapshot.appendSections([.results])
            snapshot.appendItems(resultsViewController.originalResults, toSection: .results)
            resultsViewController.dataSource.apply(snapshot)
        } else {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [self] _ in
                handleSearchingGames(title: title)
            }
        }
    }
}

extension HomeViewController: ResultsViewControllerDelegate {
    func resultsViewController(_ viewController: ResultsViewController, didSelectItem item: Item) {
        showDetailView(game: item)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        showDetailView(game: item)
    }
}
