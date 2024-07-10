//
//  GameDetailViewController.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/4/24.
//

import UIKit

class GameDetailViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let game: Game
    let dealItem: DealItem?
    var gameDetail: GameDetail?
    var deals: [Deal] = []
    var bestDeal: Deal?
    var historicDeal: Deal?
    
    var showAllDeals = false // tableview/datsource should manage state. cell should be "view only"
    
    let isThereAnyDealService =  IsThereAnyDealService()
    let steamService = SteamWebService()
    
    enum Section: Int, CaseIterable {
        case banner
        case description
        case price
        case historic
        case allPrices
    }
    
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
        navigationItem.title = game.title
        navigationItem.largeTitleDisplayMode = .never
        tableView.delegate = self   // not needed?
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), primaryAction: nil)
                
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: BannerTableViewCell.reuseIdentifier)
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: DescriptionTableViewCell.reuseIdentifier)
        tableView.register(PriceTableViewCell.self, forCellReuseIdentifier: PriceTableViewCell.reuseIdentifier)
        tableView.register(ShowMoreTableViewCell.self, forCellReuseIdentifier: ShowMoreTableViewCell.reuseIdentifier)
        tableView.register(VoucherTableViewCell.self, forCellReuseIdentifier: VoucherTableViewCell.reuseIdentifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        Task {
            do {
                guard let steamID = game.steamID else { return }
                gameDetail = try await steamService.getGameDetail(gameID: "\(steamID)")
                tableView.reloadData()
                
                if let imageUrl = gameDetail?.background_raw {
                    let backgroundView = BackgroundView()
                    await backgroundView.setImage(url: URL(string: imageUrl)!)
                    tableView.backgroundView = backgroundView
                }
            } catch {
                print("Error fetching game detail: \(error)")
            }
        }
        
        Task {
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
                    
                    tableView.reloadSections(IndexSet(arrayLiteral: Section.price.rawValue, Section.allPrices.rawValue), with: .automatic)
                    print("Voucher: \(bestDeal?.voucher)")
                }
                
            } catch {
                print("Error fetching prices")
            }
        }
        
        Task {
            do {
                let priceOverview = try await isThereAnyDealService.getPriceOverview(gameIDs: [game.id])
                historicDeal = priceOverview.prices.first?.lowest
                tableView.reloadSections(IndexSet(arrayLiteral: Section.historic.rawValue), with: .automatic)
            } catch {
                print("Error fetching prices")
            }
        }
    }

}

extension GameDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .banner:
            return 1
        case .description:
            return 1
        case .price:
            let voucher = bestDeal?.voucher != nil ? 1 : 0
            return 1 + voucher
        case .historic:
            return 1
        case .allPrices:
            let showMoreButton = deals.count > 3 ? 1 : 0
            return (showAllDeals ? deals.count : min(deals.count, 3)) + showMoreButton
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .banner:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.reuseIdentifier, for: indexPath) as! BannerTableViewCell
            guard let imageUrl = game.assets?.banner600 else { return UITableViewCell() }
            Task {
                await cell.setImage(url: URL(string: imageUrl)!)
            }
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.reuseIdentifier, for: indexPath) as! DescriptionTableViewCell
            cell.setDescription(text: gameDetail?.short_description ?? "No description.")
            return cell
        case .price:
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
        case .historic:
            let cell = tableView.dequeueReusableCell(withIdentifier: PriceTableViewCell.reuseIdentifier, for: indexPath) as! PriceTableViewCell
            if let historicDeal {
                cell.update(with: historicDeal)
            }
            return cell
        case .allPrices:
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
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else { return nil }
        switch section {
        case .banner:
            return game.title
        case .description:
            return "Synopsis"
        case .price:
            return "Current Best Deal"
        case .historic:
            return "Historical Low"
        case .allPrices:
            return "Other Deals"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == Section.price.rawValue {
            return 44
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ShowMoreTableViewCell {
            print("Did tap show more button")
            showAllDeals = !showAllDeals
            tableView.reloadSections(IndexSet(integer: Section.allPrices.rawValue), with: .automatic)
        }
    }
}
