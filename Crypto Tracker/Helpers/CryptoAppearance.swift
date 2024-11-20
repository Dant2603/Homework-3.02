//
//  CryptoAppearance.swift
//  Crypto Tracker
//
//  Created by Мария Гетманская on 21.11.2024.
//

import UIKit

struct CryptoAppearance {
    static func color(for crypto: Link) -> UIColor {
        switch crypto {
        case .bitcoin: return .orange
        case .ethereum: return .systemIndigo
        case .tether: return .green
        case .litecoin: return .gray
        case .ripple: return .blue
        case .cardano: return .systemTeal
        case .solana: return UIColor(red: 0.33, green: 0.62, blue: 0.51, alpha: 1.0)
        case .dogecoin: return UIColor(red: 0.94, green: 0.77, blue: 0.32, alpha: 1.0)
        }
    }
}

