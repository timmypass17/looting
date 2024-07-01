//
//  ViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import UIKit

// TODO: Add discount percent to banner (ex. -%50) with white text black bg or steam but orange
class HomeViewController: UIViewController {

    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
    var searchController: UISearchController!
    private var resultsViewController: ResultsViewController!

    enum Section: Hashable {
        case featured
        case standard(String) // "Steam", "Blizzard"...
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
    
    var imageTasks: [IndexPath: Task<Void, Never>] = [:]
    var searchTask: Task<Void, Never>? = nil

    let steamID = 61
    let gogID = 35
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Stores"
        navigationController?.navigationBar.prefersLargeTitles = true

        resultsViewController = ResultsViewController()
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Games By Title"
        searchController.showsSearchResultsController = true // Always show the search result controller even when search is empty
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        resultsViewController.loadViewIfNeeded()    // make sure viewDidLoad() is called so datasource is initalized
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), primaryAction: nil, menu: nil)

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

        // MARK: Register cells/supplmentary views
        collectionView.register(FeaturedDealCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedDealCollectionViewCell.reuseIdentifier)
        collectionView.register(DealSmallCollectionViewCell.self, forCellWithReuseIdentifier: DealSmallCollectionViewCell.reuseIdentifier)
        collectionView.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: StoreCollectionViewCell.reuseIdentifier)

        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.topLine, withReuseIdentifier: LineView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.bottomLine, withReuseIdentifier: LineView.reuseIdentifier)

        // MARK: Collection View Setup
        collectionView.collectionViewLayout = createLayout()

        configureDataSource() // provides cell

        // MARK: Snapshot Definition
        snapshot.appendSections([.featured, .standard("Steam"), .standard("GOG"), .shops])
        sections = snapshot.sectionIdentifiers
        
        Task {
            try await fetchAndLoadGames()
            
//            
//            let featuredDeals: [Item] = await getGames()
//            let steamID = 61
//            let gogID = 35
//            let steamDeals: [Item] = Array(await getGames(limit: 10, shops: [steamID]))
//            let gogDeals: [Item] = Array(await getGames(limit: 10, shops: [gogID]))
//            
//            // Represents collectionView's contents at a moment in time
//            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
//            snapshot.appendSections([.featured])
//            snapshot.appendItems(featuredDeals, toSection: .featured)
//
//            if steamDeals.count > 0 {
//                snapshot.appendSections([.standard("Steam")])
//                snapshot.appendItems(steamDeals, toSection: .standard("Steam"))
//            }
//            
//            if gogDeals.count > 0 {
//                snapshot.appendSections([.standard("GOG")])
//                snapshot.appendItems(gogDeals, toSection: .standard("GOG"))
//            }
//            
//            snapshot.appendSections([.shops])
//            snapshot.appendItems(shops, toSection: .shops)
//
//            sections = snapshot.sectionIdentifiers  // keep track of sections (e.g. [.featured, .standard(), .standard(), .shops])
//            await dataSource.apply(snapshot)        // update UI with current data
//            
//            // Init results view controller
//            resultsViewController.originalResults = featuredDeals
//            var resultSnapshot = NSDiffableDataSourceSnapshot<ResultsViewController.Section, Item>()
//            
//            resultSnapshot.appendSections([.results])
//            resultSnapshot.appendItems(featuredDeals, toSection: .results)
//            
//            await resultsViewController.dataSource.apply(resultSnapshot)
        }

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

                // Because the category items should align with the centered groups above them, you'll need to dynamically calculate their insets
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
            case .standard:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DealSmallCollectionViewCell.reuseIdentifier, for: indexPath) as! DealSmallCollectionViewCell
                self.imageTasks[indexPath]?.cancel()
                self.imageTasks[indexPath] = Task {
                    let isThirdItem = (indexPath.row + 1).isMultiple(of: 4)
                    await cell.update(with: itemIdentifier.game!, itemIdentifier.dealItem!, hideBottomLine: isThirdItem)
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
            var gameDeals: [(Game, DealItem)] = []
            let deals: [DealItem] = try await service.getDeals(limit: limit, shops: shops).list
            for deal in deals {
                let game: Game = try await service.getGame(id: deal.id)
                
                gameDeals.append((game, deal))
            }
            print("Game count: \(gameDeals.count)")
            return gameDeals.map { Item.game($0, $1) }
        } catch {
            print("Failed to fetch games: \(error)")
            return []
        }
    }
    
    func getGames(title: String) async -> [Item] {
        do {
            let searchItems: [SearchItem] = try await service.getSearchItems(title: title)
            var games: [Game] = []
            var prices: [Price] = []
            var items: [Item] = []
            
            for item in searchItems {
                let game: Game = try await service.getGame(id: item.id)
                games.append(game)
            }
            
            prices = try await service.getPrices(gameIDs: games.map { $0.id })
            
            for game in games {
                guard let price = prices.first(where: { $0.id == game.id }),
                      let cheapestDeal = price.deals.min(by: { $0.price.amount < $1.price.amount})
                else { continue }
                
                let dealItem = DealItem(id: game.id, title: game.title, deal: cheapestDeal)
                items.append(Item.game(game, dealItem))
            }
            
            return items
        } catch {
            print("Error fetching \(title): \(error)")
            return []
        }
    }

    func getShops() async -> [Item] {
        do {
            if Settings.shared.shops.isEmpty {
                print("Fetching shops")
                Settings.shared.shops = try await service.getShops()
            }

            let shops: [Shop] = Settings.shared.shops
            return shops.map { Item.shop($0) }
        } catch {
            return []
        }
    }
    
    // Fetches 3 apis request simulatenously
    // Managing all these tasks with a single searchTask variable and can cancel the whole TaskGroup with a single call.
    func fetchAndLoadGames() async throws {

        try await withThrowingTaskGroup(of: (Section, [Item]).self) { group in
            // Featured games
            group.addTask {
                try Task.checkCancellation()
                let featuredGames = await self.getGames()
                
                return (Section.featured, featuredGames)
            }
            
            group.addTask {
                try Task.checkCancellation()
                return (Section.standard("Steam"), await self.getGames(limit: 10, shops: [self.steamID]))
            }
            
            group.addTask {
                try Task.checkCancellation()
                return (Section.standard("GOG"), await self.getGames(limit: 10, shops: [self.gogID]))
            }
            
            group.addTask {
                try Task.checkCancellation()
                return (Section.shops, await self.getShops())
            }

            // As the result is returned from each task in the group, you process them using handleFetchedItems().
            // - the for-try-await statement process the items as they are returned in the context of the MainActor so that you can update the ui
            // - this processing could not be done in each task in the group, because they are executing concurrently
            // Process order is random because they are executing concurrently -> could return [book, music, movie, app]

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
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let title = searchBar.text else { return }
        print("Searching for \(title)...")
        
        searchTask?.cancel()
        searchTask = Task {
            let games = await getGames(title: title)
            var snapshot = NSDiffableDataSourceSnapshot<ResultsViewController.Section, Item>()
            snapshot.appendSections([.results])
            snapshot.appendItems(games, toSection: .results)
            await resultsViewController.dataSource.apply(snapshot)
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // The system calls this method when the search bar becomes the first responder or the search bar’s text changes. Perform any required filtering and updating of search results or suggestions inside of this method.
        guard let searchBarText = searchController.searchBar.text else { return }

        if searchBarText.isEmpty {
            var snapshot = NSDiffableDataSourceSnapshot<ResultsViewController.Section, Item>()
            snapshot.appendSections([.results])
            snapshot.appendItems(resultsViewController.originalResults, toSection: .results)
            resultsViewController.dataSource.apply(snapshot)
        }
    }
}
