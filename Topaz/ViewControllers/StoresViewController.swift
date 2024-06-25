//
//  StoresViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import UIKit

class StoresViewController: UIViewController {

    enum Section: Hashable {
        case featured
        case standard(String) // "Steam", "Blizzard"...
        case stores
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
    
    let service = CheapSharkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Stores"
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
        collectionView.register(StoreDealsCollectionViewCell.self, forCellWithReuseIdentifier: StoreDealsCollectionViewCell.reuseIdentifier)
        collectionView.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: StoreCollectionViewCell.reuseIdentifier)
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.topLine, withReuseIdentifier: LineView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.bottomLine, withReuseIdentifier: LineView.reuseIdentifier)
        
        // MARK: Collection View Setup
        collectionView.collectionViewLayout = createLayout()
                
        configureDataSource() // provides cell
        
        // MARK: Snapshot Definition
        Task {
            let stores: [Item] = await getStores()
            let featuredDeals: [Item] = await getFeaturedDeals()
            let deals: [Item] = await getTopDeals(using: [.steam, .humble, .greenMan])
            let steamDeals = deals.filter { $0.deal!.storeID == StoreID.steam.rawValue }
            let humbleDeals = deals.filter { $0.deal!.storeID == StoreID.humble.rawValue }
            let greenManDeals = deals.filter { $0.deal!.storeID == StoreID.greenMan.rawValue }

            // Represents collectionView's contents at a moment in time
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            snapshot.appendSections([.featured])
            snapshot.appendItems(featuredDeals, toSection: .featured)
            
            snapshot.appendSections([.standard("Steam"), .standard("Humble Store"), .standard("GreenManGaming")])
            
            snapshot.appendItems(steamDeals, toSection: .standard("Steam"))
            snapshot.appendItems(humbleDeals, toSection: .standard("Humble Store"))
            snapshot.appendItems(greenManDeals, toSection: .standard("GreenManGaming"))
            
            snapshot.appendSections([.stores])
            snapshot.appendItems(stores, toSection: .stores)
            
            sections = snapshot.sectionIdentifiers
            await dataSource.apply(snapshot)
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
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)) // square
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(300))
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
                            heightDimension: .fractionalHeight(1/3)
                        )
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.92),
                        heightDimension: .estimated(250)),
                    repeatingSubitem: item,
                    count: 3
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.boundarySupplementaryItems = [headerItem, bottomLineItem]
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 20, trailing: 0)

                return section
                
            case .stores:
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
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let section = self.sections[indexPath.section]
            switch section {
            case .featured:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedDealCollectionViewCell.reuseIdentifier, for: indexPath) as! FeaturedDealCollectionViewCell
                cell.update(with: itemIdentifier.deal!)
                
                return cell
            case .standard:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreDealsCollectionViewCell.reuseIdentifier, for: indexPath) as! StoreDealsCollectionViewCell
                
                let isThirdItem = (indexPath.row + 1).isMultiple(of: 3)
                cell.configureCell(itemIdentifier.deal!, hideBottomLine: isThirdItem)
                return cell
            case .stores:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.reuseIdentifier, for: indexPath) as! StoreCollectionViewCell
                let isLastItem = collectionView.numberOfItems(inSection: indexPath.section) == indexPath.row + 1
                cell.configureCell(itemIdentifier.store!, hideBottomLine: isLastItem)
                
                return cell
            }
        })
        
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
                case .stores:
                    sectionName = "Top Stores"
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
    
    func getFeaturedDeals() async -> [Item] {
        do {
            let deals: [Deal] = try await service.getDeals(pageSize: 10, sortBy: .dealRating)
            return deals.map { Item.deal($0) }
        } catch {
            return []
        }
    }
    
    func getStores() async -> [Item] {
        // If stores not in settings, fetch it
        do {
            if Settings.shared.stores.isEmpty {
                Settings.shared.stores = try await service.getStores()
            }
            
            let stores: [Store] = Array(Settings.shared.stores.prefix(7))
            
            return stores.map { Item.store($0) }
        } catch {
            return []
        }
    }
    
    func getTopDeals(using storeIDs: [StoreID]) async -> [Item] {
        do {
            let deals: [Deal] = try await service.getDeals(storeIDs: storeIDs.map { $0.rawValue }, pageSize: 60, sortBy: .dealRating)
            return deals.map { Item.deal($0) }
        } catch {
            return []
        }
    }
}
