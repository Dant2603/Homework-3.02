//
//  File.swift
//  Homework 3.02
//
//  Created by Мария Гетманская on 30.10.2024.
//

import Foundation

struct CryptoAsset: Decodable, CustomStringConvertible {
    let name: String
    let symbol: String
    let priceUsd: String
    let changePercent24Hr: String?

    var description: String {
        let priceUsd = Double(priceUsd) ?? 0.00
        let changePercent24Hr = Double(changePercent24Hr ?? "0.00") ?? 0.00

        return "name: \(name), symbol: \(symbol), \(String(format: "%.4f", priceUsd)), changePercent24Hr: \(String(format: "%.2f", changePercent24Hr))%"
    }
}

struct CryptoDataResponse: Decodable {
    let data: [CryptoAsset]
}

