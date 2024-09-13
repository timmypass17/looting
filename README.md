# Looting
An iOS video game deals tracker that notfies you when your games go on sale. (App Store soon)

<div style="display: flex; overflow-x: auto;">
    <img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/36/ab/4b/36ab4bc6-b2c3-3207-e3d6-b4556e3b036d/7458e303-46d5-48c0-9b1b-031ce42571e6_home.png/400x800bb.png" alt="Home" width="200" style="margin-right: 10px;">
    <img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/f1/59/18/f1591870-e262-cfb5-4844-6f3aa4a6f17a/7a400d6f-94ac-45ae-8c02-f0e0f1d69d6b_detail.png/400x800bb.png" alt="Detail" width="200" style="margin-right: 10px;">
    <img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/63/f2/bf/63f2bf78-c4d3-25f0-87f8-9e438347e159/683b1967-eec8-4a1b-9dc6-430e1f0f3a0b_detail2.png/400x800bb.png" alt="Deals" width="200" style="margin-right: 10px;">
    <img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/cf/f4/1d/cff41dc0-93d9-c4fe-d777-54b3db3f91e3/d433d882-dbee-4b39-8350-87ee4e3752ab_giveaway.png/400x800bb.png" alt="Giveaway" width="200" style="margin-right: 10px;">
    <img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/15/56/ad/1556adca-01ab-a54c-39c5-9ce369c682c5/1a9238e0-5f27-493c-823d-3b2171817193_wishlist.png/400x800bb.png" alt="Wishlist" width="200">
</div>

## Features
- Search & Compare Deals
  - Discover thousands of discounts and compare prices across 30+ stores to find the best deal.
- Live Giveaways
  - Gain access to live giveaways for games, DLC, loot, and more.
- Wishlist & Notifications
  - Add games to your wishlist and receive weekly notifications for when they go on sale.
- Price History
  - Track price history and make informed decisions about when to buy.

## Installation

### Prerequisites
- iOS 16.0+
- Xcode 15.4+

### Build Steps
1. Get a free API Key at [IsThereAnyDeal](https://isthereanydeal.com/)
2. Clone the repo
  ```sh
   git clone https://github.com/timmypass17/looting.git
   ```
3. Open `Topaz.xcodeproj` using Xcode.
4. Replace `apiKey` with your key

## Technologies used
- Swift
- UIKit (no storyboard)
- SwiftUI
  - Swift Charts
- XCTest
- Firebase
  - Firestore
  - Authentication
  - Cloud Functions
  - Messaging
- Node.js
- TypeScript

## Acknowledgements
All data used in this app is provided by
  - [IsThereAnyDeal](https://isthereanydeal.com/)
    - Source of game deal information
  - [GamerPower](https://www.gamerpower.com/)
    - Source of live giveaway data
  - [Steam Web](https://steamcommunity.com/dev)
    - Source of game details
