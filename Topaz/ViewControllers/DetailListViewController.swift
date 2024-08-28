//
//  DetailListViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/20/24.
//

import UIKit

class DetailListViewController: UIViewController {

    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()) // dummy
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let segmentedControl: UISegmentedControl =  {
        let control = UISegmentedControl()
        control.insertSegment(with: UIImage(systemName: "rectangle.grid.1x2"), at: 0, animated: true)
        control.insertSegment(with: UIImage(systemName: "rectangle.grid.3x2"), at: 1, animated: true)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .black
        return control
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    var searchTask: Task<Void, Never>? = nil
    var section: HomeViewController.Section?
    var offset = 0
    let limit = 20
    let service = IsThereAnyDealService()
    var shopID: Int?
    var layout: [Layout: UICollectionViewLayout] = [:]
    var imageTasks: [IndexPath: Task<Void, Never>] = [:]

    enum Section: Hashable {
        case list
    }
    
    enum Layout {
        case column, grid
        
        mutating func toggle() {
            switch self {
            case .column:
                self = .grid
            case .grid:
                self = .column
            }
        }
    }
    
    var activeLayout: Layout = .column {
        didSet {
            guard let layout = layout[activeLayout] else { return }
            collectionView.collectionViewLayout = layout
            
            // Note: had to entirely reset snapshot to avoid weird cell changes.
            //  - side effect: scrolls to very top after changing layout. fine
            var originalSnapshot = dataSource.snapshot()
            let tempSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            dataSource.apply(tempSnapshot, animatingDifferences: false)
            dataSource.apply(originalSnapshot, animatingDifferences: false)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        layout[.column] = generateColumnLayout()
        layout[.grid] = generateGridLayout()
        segmentedControl.addAction(didTapSegmentedControl(), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
        setupCollectionView()
        
        searchTask = Task {
            await loadGames()
            searchTask = nil
        }
    }
    
    func didTapSegmentedControl() -> UIAction {
        return UIAction { [self] _ in
            activeLayout.toggle()
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        view.addSubview(segmentedControl)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            segmentedControl.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // MARK: Register cells
        collectionView.register(DealSmallCollectionViewCell.self, forCellWithReuseIdentifier: DealSmallCollectionViewCell.reuseIdentifier)
        collectionView.register(DealMediumCollectionViewCell.self, forCellWithReuseIdentifier: DealMediumCollectionViewCell.reuseIdentifier)
        collectionView.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: GameCollectionViewCell.reuseIdentifier)

        // MARK: Collection View Setup
        collectionView.collectionViewLayout = layout[activeLayout]!

        configureDataSource()
    }
    
    private func generateGridLayout() -> UICollectionViewLayout {
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
                heightDimension: .absolute(308)),   // include top (4) and bottom (4) padding
            repeatingSubitem: item,
            count: 3
        )
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func generateColumnLayout() -> UICollectionViewLayout {
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
                heightDimension: .absolute(60)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 20, trailing: 0)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [self] collectionView, indexPath, itemIdentifier in
            switch activeLayout {
            case .column:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DealSmallCollectionViewCell.reuseIdentifier, for: indexPath) as! DealSmallCollectionViewCell
                imageTasks[indexPath]?.cancel()
                imageTasks[indexPath] = Task {
                    await cell.update(
                        title: itemIdentifier.game!.title,
                        imageURL: itemIdentifier.game!.assets?.banner400,
                        deal: itemIdentifier.dealItem!.deal)
                    imageTasks[indexPath] = nil
                }
                return cell
            case .grid:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DealMediumCollectionViewCell.reuseIdentifier, for: indexPath) as! DealMediumCollectionViewCell
                imageTasks[indexPath]?.cancel()
                imageTasks[indexPath] = Task {
                    await cell.update(game: itemIdentifier.game!, dealItem: itemIdentifier.dealItem!)
                    imageTasks[indexPath] = nil
                }
                return cell
            }
        }
    }
    
    private func loadGames() async {
        if section == .medium("Most Popular") {
            await loadMostPopular(offset: offset)
        } else if section == .medium("Most Waitlisted") {
            await loadMostWaitlisted(offset: offset)
        } else if section == .standard("Steam") {
            let steamID = 61
            await loadGamesByShop(shopID: steamID, offset: offset)
        } else if section == .standard("GOG") {
            let gogID = 35
            await loadGamesByShop(shopID: gogID, offset: offset)
        } else if section == .shops {
            await loadGamesByShop(shopID: shopID!, offset: offset)
        }
    }
    
    func loadGamesByShop(shopID: Int, offset: Int = 0) async {
        let items: [Item] = await getGames(offset: offset, shops: [shopID])
        self.offset += limit
        
        let currentItems: [Item] = dataSource.snapshot(for: .list).items
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.list])
        snapshot.appendItems(currentItems + items)
        await dataSource.apply(snapshot)
    }
   
    func getGames(offset: Int, shops: [Int] = []) async -> [Item] {
        do {
            var gameDealsMap: [String: (Game, DealItem)] = [:]
            let deals: [DealItem] = try await service.getDeals(offset: offset, shops: shops).list
            
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
    
    func loadMostWaitlisted(offset: Int = 0) async {
        let items: [Item] = await getMostWaitlisted(offset: offset)
        self.offset += limit
        
        let currentItems: [Item] = dataSource.snapshot(for: .list).items
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.list])
        snapshot.appendItems(currentItems + items)
        await dataSource.apply(snapshot)
    }
    
    func getMostWaitlisted(offset: Int) async -> [Item] {
        do {
            let waitlist: [Stat] = try await service.getMostWaitlist(offset: offset)
            let games = await self.getGames(gameIDs: waitlist.map { $0.id })
            return games
        } catch {
            print("Error fetching waitlist: \(error)")
            return []
        }
    }
    
    func loadMostPopular(offset: Int) async {
        let items: [Item] = await getMostPopular(offset: offset)
        self.offset += limit
        
        let currentItems: [Item] = dataSource.snapshot(for: .list).items
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.list])
        snapshot.appendItems(currentItems + items)
        await dataSource.apply(snapshot)
        print(snapshot.itemIdentifiers.count)
    }
    
    func getMostPopular(offset: Int) async -> [Item] {
        do {
            let popular: [Stat] = try await service.getPopular(offset: offset)
            let games = await getGames(gameIDs: popular.map { $0.id })
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
}

extension DetailListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 ) {
            print("Load more data \(indexPath.row)")
            searchTask?.cancel()
            searchTask = Task {
                await loadGames()
                searchTask = nil
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        showDetailView(game: item)
    }
    
    
    private func showDetailView(game item: Item) {
        let detailViewController = GameDetailViewController(game: item.game!, dealItem: item.dealItem!)
        if let wishlistViewController = (tabBarController?.viewControllers?[2] as? UINavigationController)?.viewControllers[0] as? WishlistViewController {
            detailViewController.delegate = wishlistViewController
        }
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
