//
//  Link.swift
//  Crypto Tracker
//
//  Created by Мария Гетманская on 21.11.2024.
//

import Foundation

private let baseURL = "https://api.coincap.io/v2/assets?search="
private let logoBaseURL = "https://static.coinpaprika.com/coin/"

// MARK: - Link Enum
enum Link: CaseIterable {
    case bitcoin, ethereum, tether, litecoin, ripple, cardano, solana, dogecoin
    
    var name: String {
        switch self {
        case .bitcoin: "Bitcoin"
        case .ethereum: "Ethereum"
        case .tether: "Tether"
        case .litecoin: "Litecoin"
        case .ripple: "Ripple"
        case .cardano: "Cardano"
        case .solana: "Solana"
        case .dogecoin: "Dogecoin"
        }
    }
    
    var symbol: String {
        switch self {
        case .bitcoin: "BTC"
        case .ethereum: "ETH"
        case .tether: "USDT"
        case .litecoin: "LTC"
        case .ripple: "XRP"
        case .cardano: "ADA"
        case .solana: "SOL"
        case .dogecoin: "DOGE"
        }
    }
    
    private var apiID: String {
        switch self {
        case .bitcoin: "btc-bitcoin"
        case .ethereum: "eth-ethereum"
        case .tether: "usdt-tether"
        case .litecoin: "ltc-litecoin"
        case .ripple: "xrp-xrp"
        case .cardano: "ada-cardano"
        case .solana: "sol-solana"
        case .dogecoin: "doge-dogecoin"
        }
    }
    
    var url: URL {
        URL(string: baseURL + symbol)!
    }
    
    var logoURL: URL {
        URL(string: "\(logoBaseURL)\(apiID)/logo.png")!
    }
}

// MARK: - Extension for Default Asset
extension Link {
    var defaultAsset: CryptoAsset {
        CryptoAsset(
            id: self.name.lowercased(),
            rank: "N/A",
            symbol: self.symbol,
            name: "\(self.name) (Unavailable)",
            supply: "N/A",
            maxSupply: "N/A",
            marketCapUsd: "N/A",
            volumeUsd24Hr: "N/A",
            priceUsd: "N/A",
            changePercent24Hr: "N/A",
            explorer: nil
        )
    }
}
