//
//  GameDetailViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/4/24.
//

import UIKit
import SafariServices
import FirebaseAuth
import FirebaseFirestore
import AVFoundation
import AVKit
import SwiftUI

protocol GameDetailViewControllerDelegate: AnyObject {
    func gameDetailViewController(_ viewController: GameDetailViewController, didWishlistGame game: Game, price: Double?)
    func gameDetailViewController(_ viewController: GameDetailViewController, didUnwishlistGame game: Game)
}

class GameDetailViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var game: Game?
    var dealItem: DealItem?
    var gameDetail: GameDetail?
    var deals: [Deal] = []
    var bestDeal: Deal?
    var historicDeal: Deal?
    var user: User?
    var history: [History] = []
    
    var showAllDeals = false // tableview/datsource should manage state. cell should be "view only"
    var favoriteButton: UIBarButtonItem!
    var favoriteButtonIsSelected = false    // using barButtonItem.isSelected makes button highlight (ugly), can't disable highlight
    
    let isThereAnyDealService = IsThereAnyDealService()
    let steamService = SteamWebService()
    
    var db = Firestore.firestore()
    var listener: ListenerRegistration?
    var authListener: AuthStateDidChangeListenerHandle?
    
    weak var delegate: GameDetailViewControllerDelegate?
    
    enum Section: Int, CaseIterable {
        case cover
        case info
        case screenshots
        case bestDeal
        case allDeals
        case history
        case historicalLow
        
        var index: Int {
            return self.rawValue
        }
    }
    
    // TODO: Just use deal
    init(game: Game, dealItem: DealItem?) {
        self.game = game
        self.dealItem = dealItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = game?.title
        navigationItem.largeTitleDisplayMode = .never
        tableView.delegate = self   // not needed?
        tableView.dataSource = self
        
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"), primaryAction: didTapWishlistButton())
        favoriteButton.target = self
        navigationItem.rightBarButtonItem = favoriteButton
                
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: BannerTableViewCell.reuseIdentifier)
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: DescriptionTableViewCell.reuseIdentifier)
        tableView.register(PriceTableViewCell.self, forCellReuseIdentifier: PriceTableViewCell.reuseIdentifier)
        tableView.register(ShowMoreTableViewCell.self, forCellReuseIdentifier: ShowMoreTableViewCell.reuseIdentifier)
        tableView.register(VoucherTableViewCell.self, forCellReuseIdentifier: VoucherTableViewCell.reuseIdentifier)
        tableView.register(RightDetailTableViewCell.self, forCellReuseIdentifier: RightDetailTableViewCell.reuseIdentifier)
        tableView.register(ScreenshotsTableViewCell.self, forCellReuseIdentifier: ScreenshotsTableViewCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: HistoryView.reuseIdentifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        
        authListener = Auth.auth().addStateDidChangeListener { [self] auth, user in
            handleAuthState(user: user)
        }
        
        
        Task {
            await loadAdditionalGameInfo()
        }
        
        Task {
            await loadPrices()
        }
        
        Task {
            await loadPriceOverview()
        }
        
        Task {
            await loadHistory()
        }
    }
    
    func handleAuthState(user: User?) {
        guard let game: Game else { return }
        if let user {
            self.user = user
            favoriteButton.isEnabled = true
            
            // maybe remove in viewwilldisappear when use preses back
            listener = db.collection("users")
                .document(user.uid)
                .collection("wishlist")
                .document(game.id)
                .addSnapshotListener { [self] documentSnapshot, error in
                    guard let documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }

                    if let wishlistItem = try? documentSnapshot.data(as: WishlistItem.self) {
                        print("Current data: \(wishlistItem.title)")
                        favoriteButton.image = UIImage(systemName: "star.fill")
                        favoriteButtonIsSelected = true
                    } else {
                        print("Document not found")
                        favoriteButton.image = UIImage(systemName: "star")
                        favoriteButtonIsSelected = false
                    }
                }
        } else {
            self.user = nil
            favoriteButton.isEnabled = false
            listener?.remove()
        }
    }
    
    func loadAdditionalGameInfo() async {
        guard let game else { return }

        do {
            guard let steamID = game.steamID else { return }
            gameDetail = try await steamService.getGameDetail(gameID: "\(steamID)")
            tableView.reloadData()
            
            if let imageUrl = gameDetail?.backgroundURL {
                let backgroundView = GameBackgroundView()
                await backgroundView.setImage(url: URL(string: imageUrl)!)
                tableView.backgroundView = backgroundView
            }
        } catch {
            print("Error fetching game detail: \(error)")
        }
    }
    
    func loadPrices() async {
        guard let game else { return }

        do {
            if let price = try await isThereAnyDealService.getPrices(gameIDs: [game.id]).first {
                deals = price.deals
                if let minCost = (deals.min { $0.price.amount < $1.price.amount })?.price.amount {
                    // Get all deals with minCost
                    let lowestDeals = deals.filter { $0.price.amount == minCost }
                    // Use steam version if it exists
                    if let steamDeal = lowestDeals.first(where: { $0.shop.name == "Steam" }) {
                        bestDeal = steamDeal
                    } else {
                        // Choose first
                        bestDeal = lowestDeals.first
                    }
                }
                // Filter out best deal from list of deals
                deals = deals.filter { $0 != bestDeal }
                
                tableView.reloadSections(IndexSet(arrayLiteral: Section.bestDeal.rawValue, Section.allDeals.rawValue), with: .automatic)
            }
            
        } catch {
            print("Error fetching prices")
        }
    }
    
    func loadHistory() async {
        guard let game else { return }
        do {
            history = try await isThereAnyDealService.getHistory(gameID: game.id)
            tableView.reloadSections(IndexSet(integer: Section.history.rawValue), with: .automatic)
        } catch {
            print("Error fetching history: \(error)")
        }
    }
    
    func loadPriceOverview() async {
        guard let game else { return }
        do {
            let priceOverview = try await isThereAnyDealService.getPriceOverview(gameIDs: [game.id])
            historicDeal = priceOverview.prices.first?.lowest
            tableView.reloadSections(IndexSet(arrayLiteral: Section.historicalLow.rawValue), with: .automatic)
        } catch {
            print("Error fetching prices: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    @objc func didTapWishlistButton() -> UIAction {
        return UIAction { [self] _ in
            guard let game,
                  let userID = Auth.auth().currentUser?.uid else {
                print("User is not authenticated")
                return
            }
            
            if favoriteButtonIsSelected {
                print("Remove \(game.title) from wishlist")
                db.collection("users")
                    .document(userID)
                    .collection("wishlist")
                    .document(game.id)
                    .delete()
                delegate?.gameDetailViewController(self, didUnwishlistGame: game)
            } else {
                print("Add \(game.title) to wishlist")
                let wishlistItem = WishlistItem(
                    userID: userID,
                    gameID: game.id,
                    title: game.title,
                    regularPrice: dealItem?.deal?.regular.amount,
                    posterURL: game.assets?.banner400
                )
                
                do {
                    try db.collection("users")
                        .document(userID)
                        .collection("wishlist")
                        .document(game.id)
                        .setData(from: wishlistItem)    // creates/overwrites
                    
                    delegate?.gameDetailViewController(self, didWishlistGame: game, price: dealItem?.deal?.regular.amount)
                    print("Document added with ID: \(userID + game.id)")
                } catch {
                    print("Error adding document: \(error)")
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let sections: [Section] = [.cover, .info, .historicalLow]
        if sections.map({ $0.rawValue }).contains(indexPath.section)  {
            return nil
        }
        
        return indexPath
    }
}

extension GameDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .cover:
            return 1
        case .info:
            return 7
        case .screenshots:
            return 1
        case .bestDeal:
            let voucher = bestDeal?.voucher != nil ? 1 : 0
            return 1 + voucher
        case .historicalLow:
            return 1
        case .allDeals:
            let showMoreButton = deals.count > 3 ? 1 : 0
            return (showAllDeals ? deals.count : min(deals.count, 3)) + showMoreButton
        case .history:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let game, let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .cover:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.reuseIdentifier, for: indexPath) as! BannerTableViewCell
            cell.selectionStyle = .none
            guard let imageUrl = game.assets?.banner600 else { return UITableViewCell() }
            Task {
                await cell.setImage(url: URL(string: imageUrl)!)
            }
            return cell
        case .info:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.reuseIdentifier, for: indexPath) as! DescriptionTableViewCell
                cell.setDescription(text: gameDetail?.description ?? "No description.")
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: RightDetailTableViewCell.reuseIdentifier, for: indexPath) as! RightDetailTableViewCell
            cell.selectionStyle = .none
            if indexPath.row == 1 {
                cell.update(title: "Review",
                            description: "\(game.steamReviewText ?? "") (\(gameDetail?.recommendations.total.formatted() ?? "0"))")
            } else if indexPath.row == 2 {
                cell.update(title: "Rating", description: "\(game.steamReview?.score ?? 0)")
            } else if indexPath.row == 3 {
                cell.update(title: "Release Date", description: gameDetail?.releaseDate.date ?? "")
            } else if indexPath.row == 4 {
                cell.update(title: "Genres", description: gameDetail?.genres.map { $0.description }.joined(separator: ", ") ?? "")
            } else if indexPath.row == 5 {
                cell.update(title: "Developer", description: gameDetail?.developers.first ?? "")
            } else if indexPath.row == 6 {
                cell.update(title: "Publisher", description: gameDetail?.publishers.first ?? "")
            }
            return cell
        case .screenshots:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScreenshotsTableViewCell.reuseIdentifier, for: indexPath) as! ScreenshotsTableViewCell
            cell.delegate = self
            Task {
                await cell.update(movies: gameDetail?.movies ?? [], screenshots: gameDetail?.screenshots ?? [])
                
            }
            return cell
        case .bestDeal:
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: VoucherTableViewCell.reuseIdentifier, for: indexPath) as! VoucherTableViewCell
                if let voucher = bestDeal?.voucher {
                    cell.update(voucher: voucher)
                }
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PriceTableViewCell.reuseIdentifier, for: indexPath) as! PriceTableViewCell
            if let bestDeal {
                cell.update(with: bestDeal)
            }
            return cell
        case .historicalLow:
            let cell = tableView.dequeueReusableCell(withIdentifier: PriceTableViewCell.reuseIdentifier, for: indexPath) as! PriceTableViewCell
            cell.selectionStyle = .none
            if let historicDeal {
                cell.update(with: historicDeal)
            }

            return cell
        case .allDeals:
            if !showAllDeals && indexPath.row == min(deals.count, 3) {
                let cell = tableView.dequeueReusableCell(withIdentifier: ShowMoreTableViewCell.reuseIdentifier, for: indexPath) as! ShowMoreTableViewCell
                cell.titleLabel.text = "Show More"
                cell.acessoryImageView.image = UIImage(systemName: "chevron.right")
                return cell
            }
            
            if showAllDeals && indexPath.row == deals.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: ShowMoreTableViewCell.reuseIdentifier, for: indexPath) as! ShowMoreTableViewCell
                cell.titleLabel.text = "Show Less"
                cell.acessoryImageView.image = UIImage(systemName: "chevron.down")
                return cell
            }
            
            // Show less button
            let cell = tableView.dequeueReusableCell(withIdentifier: PriceTableViewCell.reuseIdentifier, for: indexPath) as! PriceTableViewCell
            let deal = deals[indexPath.row]
            cell.update(with: deal)
            return cell
        case .history:
            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryView.reuseIdentifier, for: indexPath)
            cell.contentConfiguration = UIHostingConfiguration {
                HistoryView(history: history)
                    .padding(.vertical)
                    .frame(height: 200)
            }
            return cell
        }
    }

}

extension GameDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else { return nil }
        switch section {
        case .cover:
            return nil
        case .info:
            return game?.title
        case .screenshots:
            return "Screenshots"
        case .bestDeal:
            return "Current Best Deal"
        case .historicalLow:
            return "Historical Low"
        case .allDeals:
            return "All Deals"
        case .history:
            return "Steam Price History"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ShowMoreTableViewCell {
            showAllDeals.toggle()
            tableView.reloadSections(IndexSet(integer: Section.allDeals.rawValue), with: .automatic)
        } else if let cell = tableView.cellForRow(at: indexPath) as? PriceTableViewCell {
            guard indexPath.section != Section.historicalLow.index else { return }
            var url: URL? = nil
            if indexPath.section == Section.bestDeal.rawValue {
                guard let urlString = bestDeal?.url else { return }
                url = URL(string: urlString)
            } else {
                guard let urlString = deals[indexPath.row].url else { return }
                url = URL(string: urlString)
            }
            
            if let url {
                present(SFSafariViewController(url: url), animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Fixes bug where movie section is squished when fetching movies cause slow
        let movieIndexPath = IndexPath(row: 0, section: 2)
        if indexPath == movieIndexPath {
            let tableViewWidth = tableView.frame.width
            let layoutMargins = tableView.layoutMargins
            let horizontalInset = layoutMargins.left + layoutMargins.right
            let cellWidth = tableViewWidth - horizontalInset

            let height = (337 / 600) * cellWidth
            return height
        }
        
        return UITableView.automaticDimension
    }
    
}

extension GameDetailViewController: ScreenshotsTableViewCellDelegate {
    func screenshotsTableViewCell(_ sender: ScreenshotsTableViewCell, didTapMovie movie: Movie) {
        let videoURL = URL(string: movie.mp4.videoURL)!
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
}
