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
    var imageTasks: [IndexPath: Task<Void, Never>] = [:]
    
    var listener: ListenerRegistration?
    var lastDocument: QueryDocumentSnapshot?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self

        navigationItem.title = "Wishlist"
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
        configureDataSource() // provides cell
        
        // Don't use realtime listneers with pagination (tricky)
        // Just use 1 time fetch and use swipe to refresh
        
        Auth.auth().addStateDidChangeListener { [self] auth, user in
            if let user {
                self.user = user
                button.isHidden = true
                
                // Initalize 10 games fetch
                Task {
                    await loadWishlist()
                }

            } else {
                button.isHidden = false
                listener?.remove()
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                snapshot.appendSections([.wishlist])
                snapshot.appendItems([], toSection: .wishlist)
                dataSource.apply(snapshot)
            }
        }
    }
    
    // Generic method to load wishlist data
    private func loadWishlist(after document: DocumentSnapshot? = nil) async {
        do {
            guard let user else { return }
            
            // Query to get first 10 games
            var query = db.collection("wishlist")
                .whereField("userID", isEqualTo: user.uid)
                .limit(to: 10)
            
            if let lastDocument = document {
                // Query to get 10 games after last document fetch
                query = query
                    .start(afterDocument: lastDocument)
            }

            let querySnapshot = try await query.getDocuments()
            lastDocument = querySnapshot.documents.last
            
            let wishlist: [WishlistItem] = querySnapshot.documents
                .compactMap { try? $0.data(as: WishlistItem.self) }
            
            let items: [Item] = await getGames(gameIDs: wishlist.map { $0.gameID })
            updateSnapshot(with: items)
        } catch {
            print("Error loading wishlist: \(error)")
        }
    }
    
    // Update the collection view snapshot
    private func updateSnapshot(with items: [Item]) {
        let currentItems = dataSource.snapshot().itemIdentifiers
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.wishlist])
        snapshot.appendItems(currentItems + items, toSection: .wishlist)
        dataSource.apply(snapshot)
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
//                await cell.update(with: itemIdentifier.game!, itemIdentifier.dealItem!)
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
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 ) {   //it's your last cell
          //Load more data & reload your collection view
            print("Load more data \(indexPath.row)")
            Task {
                if let lastDocument {
                    await loadWishlist(after: lastDocument)
                }
            }
        }
    }
}
