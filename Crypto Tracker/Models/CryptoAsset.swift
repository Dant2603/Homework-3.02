//
//  File.swift
//  Homework 3.02
//
//  Created by Мария Гетманская on 30.10.2024.
//

import Foundation

struct CryptoAsset: Decodable {
    let id: String
    let rank: String?
    let symbol: String
    let name: String
    let supply: String?
    let maxSupply: String?
    let marketCapUsd: String?
    let volumeUsd24Hr: String?
    let priceUsd: String
    let changePercent24Hr: String?
    let explorer: String?
    
    init(
        id: String,
        rank: String?,
        symbol: String,
        name: String,
        supply: String?,
        maxSupply: String?,
        marketCapUsd: String?,
        volumeUsd24Hr: String?,
        priceUsd: String,
        changePercent24Hr: String?,
        explorer: String?
    ) {
        self.id = id
        self.rank = rank
        self.symbol = symbol
        self.name = name
        self.supply = supply
        self.maxSupply = maxSupply
        self.marketCapUsd = marketCapUsd
        self.volumeUsd24Hr = volumeUsd24Hr
        self.priceUsd = priceUsd
        self.changePercent24Hr = changePercent24Hr
        self.explorer = explorer
    }
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
              let symbol = json["symbol"] as? String,
              let name = json["name"] as? String,
              let priceUsd = json["priceUsd"] as? String else {
            return nil
        }
        
        self.id = id
        self.rank = json["rank"] as? String
        self.symbol = symbol
        self.name = name
        self.supply = json["supply"] as? String
        self.maxSupply = json["maxSupply"] as? String
        self.marketCapUsd = json["marketCapUsd"] as? String
        self.volumeUsd24Hr = json["volumeUsd24Hr"] as? String
        self.priceUsd = priceUsd
        self.changePercent24Hr = json["changePercent24Hr"] as? String
        self.explorer = json["explorer"] as? String
    }
}

struct CryptoDataResponse: Decodable {
    let data: [CryptoAsset]
}

struct CryptoData {
    let asset: CryptoAsset
    let imageData: Data?
}
