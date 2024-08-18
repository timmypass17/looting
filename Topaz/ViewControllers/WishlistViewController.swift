//
//  WishlistViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore

class WishlistViewController: UIViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    var db: Firestore = Firestore.firestore()

    enum Section: Hashable {
        case wishlist
    }
    
    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()) // dummy
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let button: GIDSignInButton = {
        let button = GIDSignInButton(frame: .zero)
        button.colorScheme = .dark
        button.style = .wide
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let service = IsThereAnyDealService()
    var wishlistTask: Task<Void, Never>? = nil
    var detailTask: Task<Void, Never>? = nil
    var imageTasks: [IndexPath: Task<Void, Never>] = [:]
    var priceTask: Task<Void, Never>? = nil
    
    var lastDocument: QueryDocumentSnapshot?
    var user: User?
    
    var isNotificationBellOn = false
    
    override func viewDidLoad() {
        print("WishlistViewController viewDidLoad()")
        super.viewDidLoad()
        collectionView.delegate = self

        navigationItem.title = "Wishlist"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"), primaryAction: didTapNotificationButton())
        
        button.addAction(didTapGoogleSignIn(), for: .touchUpInside)
        
        view.addSubview(collectionView)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        
        collectionView.register(DealSmallCollectionViewCell.self, forCellWithReuseIdentifier: DealSmallCollectionViewCell.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addAction(didSwipeToRefresh(), for: .valueChanged)
        configureDataSource() // provides cell
        
        // Don't use realtime listneers with pagination (tricky)
        // - Complicated to maintain multible realtime listeners for each paginated items
        // Just use 1 time fetch and use swipe to refresh
        
        Auth.auth().addStateDidChangeListener { [self] auth, user in
            if let user {
                self.user = user
                button.isHidden = true
                
                wishlistTask?.cancel()
                wishlistTask = Task {
                    await loadWishlist()
                    wishlistTask = nil
                }

            } else {
                button.isHidden = false
                clearDatasource()
            }
        }

        updateUI()
    }
    
    // All UI pain here
    func updateUI() {
        updateBellButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Task {
            await showNotificationPermissionAlert()
        }
        
        UNUserNotificationCenter.current().getNotificationSettings { [self] settings in
            switch settings.authorizationStatus {
            case .authorized:
                isNotificationBellOn = true
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bell")
            default:
                isNotificationBellOn = false
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bell.slash")
            }
        }
    }
    
    func showNotificationPermissionAlert() async {
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            UIApplication.shared.registerForRemoteNotifications()   // required, doesn't matter if user said yes or no just call it
            updateUI()
        } catch {
            print("Error requesting notifcations: \(error)")
        }
    }
    
    func didTapNotificationButton() -> UIAction {
        return UIAction { [self] _ in
            let title: String
            let message: String
            
            if isNotificationBellOn {
                title = "Disable Notifications for Game Sales"
                message = "Open the Settings app, tap on Notifications, and choose our app to turn off notifications."
            } else {
                title = "Enable Notifications for Game Sales"
                message = "Open the Settings app, tap on Notifications, and choose our app to enable notifications for your wishlist games. Get notified every Friday at 19:00 UTC for weekly games on sale in your wishlist."
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func updateBellButton() {
        UNUserNotificationCenter.current().getNotificationSettings { [self] settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Authorized")
                isNotificationBellOn = true
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bell")
            default:
                print("Not authorized")
                isNotificationBellOn = false
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bell.slash")
            }
        }
    }
    
    // Generic method to load wishlist data
    private func loadWishlist(after document: DocumentSnapshot? = nil) async {
        print(#function)
        do {
            guard let user else { return }
            
            // Query to get first 20 games
            var query = db.collection("users")
                .document(user.uid)
                .collection("wishlist")
                .order(by: "createdAt", descending: true) // require composite index
                .limit(to: 20)
            
            if let lastDocument = document {
                // Query to get 20 games after last document fetch
                query = query
                    .start(afterDocument: lastDocument)
            }

            let querySnapshot = try await query.getDocuments()
            lastDocument = querySnapshot.documents.last
            
            let wishlist: [WishlistItem] = querySnapshot.documents
                .compactMap { try? $0.data(as: WishlistItem.self) }
            
            let items: [Item] = await getGames(gameIDs: wishlist.map { $0.gameID })
            print("Got games: \(items.count)")
            let currentItems = dataSource.snapshot().itemIdentifiers
            updateSnapshot(with: currentItems + items)
        } catch {
            print("Error loading wishlist: \(error)")
        }
    }
    
    func didSwipeToRefresh() -> UIAction {
        return UIAction { [self] _ in
            wishlistTask?.cancel()
            wishlistTask = Task {
                collectionView.refreshControl?.beginRefreshing()
                updateSnapshot(with: [])
                lastDocument = nil
                await loadWishlist()
                collectionView.refreshControl?.endRefreshing()
                wishlistTask = nil
            }
        }
    }
    
    // Update the collection view snapshot
    private func updateSnapshot(with items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.wishlist])
        snapshot.appendItems(items, toSection: .wishlist)
        dataSource.apply(snapshot)
    }
    
    private func clearDatasource() {
        updateSnapshot(with: [])
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
                await cell.update(
                    title: itemIdentifier.wishlistItem!.title,
                    imageURL: itemIdentifier.wishlistItem!.posterURL,
                    deal: itemIdentifier.wishlistItem!.deal)
                self.imageTasks[indexPath] = nil
            }
            return cell
        }
    }
    
    func didTapGoogleSignIn() -> UIAction {
        return UIAction { _ in
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            // Start the google sign in flow!
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
                guard error == nil,
                      let user = result?.user,
                      let idToken = user.idToken?.tokenString
                else { return }
    
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

                Auth.auth().signIn(with: credential) { result, error in
                  // At this point, our user is signed in
                    print("Signed in: \(result)")
                }
            }
        }
    }
    
    private func getGames(gameIDs: [String]) async -> [Item] {
        do {
            guard let user = Auth.auth().currentUser else { return [] }
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
                
                let wishlistItem = WishlistItem(
                    userID: user.uid,
                    gameID: game.id,
                    title: game.title,
                    regularPrice: cheapestDeal.regular.amount,
                    posterURL: game.assets?.banner400,
                    deal: cheapestDeal
                )
                
                items.append(.wishlistItem(wishlistItem))
            }
            
            return items
        } catch {
            print("Error getting games: \(error)")
            return []
        }
    }
    
    private func showDetailView(game item: Item) {
        detailTask?.cancel()
        detailTask = Task {
            do {
                let game = try await service.getGame(id: item.wishlistItem!.gameID)
                let dealItem = DealItem(id: item.wishlistItem!.gameID, title: item.wishlistItem!.title)
                let detailViewController = GameDetailViewController(game: game, dealItem: dealItem)
                detailViewController.delegate = self
                navigationController?.pushViewController(detailViewController, animated: true)
                detailTask = nil
            } catch {
                print("Error fetching game: \(error)")
                detailTask = nil
            }
        }
    }
}

extension WishlistViewController {
    enum Item: Hashable {
        case wishlistItem(WishlistItem)
        
        var wishlistItem: WishlistItem? {
            if case .wishlistItem(let wishlistItem) = self {
                return wishlistItem
            } else {
                return nil
            }
        }
    }
}

extension WishlistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        showDetailView(game: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 ) {   //it's your last cell
            // Pagination
            print("Load more data \(indexPath.row)")
            wishlistTask?.cancel()
            wishlistTask = Task {
                if let lastDocument {
                    await loadWishlist(after: lastDocument)
                    wishlistTask = nil
                }
            }
        }
    }
    
}

extension WishlistViewController: GameDetailViewControllerDelegate {
    func gameDetailViewController(_ viewController: GameDetailViewController, didWishlistGame game: Game, price: Double?) {
        // datasource not init until user opens wishlist view. Should preload wishlist
        let gameInWishlist = dataSource.snapshot().itemIdentifiers.contains { $0.wishlistItem!.gameID == game.id }
        guard let user,
              !gameInWishlist 
        else { return }
        
        priceTask?.cancel()
        priceTask = Task {
            guard let currentPrice = try? await service.getPrices(gameIDs: [game.id]).first,
                  let cheapestDeal = currentPrice.deals.min(by: { $0.price.amount < $1.price.amount })
            else { return }
            
            let item: Item = Item.wishlistItem(
                WishlistItem(
                    userID: user.uid,
                    gameID: game.id,
                    title: game.title,
                    regularPrice: price,
                    posterURL: game.assets?.banner400,
                    deal: cheapestDeal
                )
            )
            
            let currentItems = dataSource.snapshot().itemIdentifiers
            updateSnapshot(with: [item] + currentItems)
            print("didWishlistGame: \(game.title)")
            priceTask = nil
        }
    }
    
    func gameDetailViewController(_ viewController: GameDetailViewController, didUnwishlistGame game: Game) {
        let gameInWishlist = dataSource.snapshot().itemIdentifiers.contains { $0.wishlistItem!.gameID == game.id }
        guard gameInWishlist else { return }
        
        var currentItems = dataSource.snapshot().itemIdentifiers
        currentItems = currentItems.filter { $0.wishlistItem!.gameID != game.id }
        updateSnapshot(with: currentItems)
        print("didWishlistGame: \(game.title)")
    }
}
