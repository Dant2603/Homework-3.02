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
}

struct CryptoDataResponse: Decodable {
    let data: [CryptoAsset]
}

struct CryptoData {
    let asset: CryptoAsset
    let imageData: Data?
}
