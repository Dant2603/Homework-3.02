//
//  CryptoCell.swift
//  Homework 3.02
//
//  Created by Мария Гетманская on 08.11.2024.
//

import UIKit

final class CryptoCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var priceChangeLabel: UILabel!
    
    // MARK: - Configuration
    func configure(with cryptoAsset: CryptoAsset, color: UIColor, logo: UIImage?, placeholder: UIImage?) {
        nameLabel.text = cryptoAsset.name
        nameLabel.textColor = color
        
        if let priceUsd = Double(cryptoAsset.priceUsd) {
            priceLabel.text = formatCurrency(priceUsd)
        } else {
            priceLabel.text = "Price: N/A"
        }
        
        if let changePercent = Double(cryptoAsset.changePercent24Hr ?? "") {
            priceChangeLabel.text = formatPercentage(changePercent)
            priceChangeLabel.textColor = changePercent >= 0 ? UIColor.systemGreen : UIColor.systemRed
        } else {
            priceChangeLabel.text = "N/A"
            priceChangeLabel.textColor = .gray
        }
        
        if let logo = logo {
            logoImageView.image = logo
            activityIndicator.stopAnimating()
        } else {
            logoImageView.image = placeholder
            activityIndicator.startAnimating()
        }
    }
    
    // MARK: - Update Appearance
    func updateAppearance(isEnabled: Bool) {
        contentView.alpha = isEnabled ? 1.0 : 0.5
    }
    
    // MARK: - Helper Methods
    private func formatCurrency(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 4
        formatter.currencySymbol = "$"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    private func formatPercentage(_ number: Double) -> String {
        return String(format: "%.2f%%", number)
    }
}
