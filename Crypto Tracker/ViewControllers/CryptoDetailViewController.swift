//
//  CryptoDetailViewController.swift
//  Crypto Tracker
//
//  Created by Мария Гетманская on 10.11.2024.
//

import UIKit

final class CryptoDetailViewController: UIViewController {
    
    // MARK: - Properties
    var cryptoAsset: CryptoAsset?
    var logoImage: UIImage?
    
    // MARK: - Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var supplyLabel: UILabel!
    @IBOutlet weak var maxSupplyLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var explorerButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Configuration
    private func configureView() {
        guard let cryptoAsset else { return }
        
        title = "\(cryptoAsset.name) (\(cryptoAsset.symbol))"
        logoImageView.image = logoImage
        
        if let priceUsd = Double(cryptoAsset.priceUsd) {
            let formattedPrice = formatNumber(priceUsd, maximumFractionDigits: 2, useCurrencyStyle: true)
            priceLabel.text = formattedPrice
        } else {
            priceLabel.text = "Price: N/A"
        }
        
        if let rank = cryptoAsset.rank {
            rankLabel.text = "Rank: \(rank)"
        } else {
            rankLabel.text = "Rank: N/A"
        }
        
        if let supplyString = cryptoAsset.supply,
           let supply = Double(supplyString) {
            let formattedSupply = formatNumber(supply, maximumFractionDigits: 0)
            supplyLabel.text = "Supply (in circulation): \(formattedSupply) \(cryptoAsset.symbol)"
        } else {
            supplyLabel.text = "Supply (in circulation): N/A"
        }
        
        if let maxSupplyString = cryptoAsset.maxSupply,
           let maxSupply = Double(maxSupplyString) {
            let formattedMaxSupply = String(format: "%.0f", maxSupply)
            maxSupplyLabel.text = "Max Supply: \(formattedMaxSupply) \(cryptoAsset.symbol)"
        } else {
            maxSupplyLabel.text = "Max Supply: N/A"
        }
        
        if let marketCapString = cryptoAsset.marketCapUsd,
           let marketCap = Double(marketCapString) {
            let formattedMarketCap = formatNumber(marketCap, maximumFractionDigits: 2, useCurrencyStyle: true)
            marketCapLabel.text = "Market Capitalization: \(formattedMarketCap)"
        } else {
            marketCapLabel.text = "Market Capitalization: N/A"
        }
        
        if let volumeString = cryptoAsset.volumeUsd24Hr,
           let volume = Double(volumeString) {
            let formattedVolume = formatNumber(volume, maximumFractionDigits: 2, useCurrencyStyle: true)
            volumeLabel.text = "24h Trading Volume: \(formattedVolume)"
        } else {
            volumeLabel.text = "24h Trading Volume: N/A"
        }
        
        if let changePercentString = cryptoAsset.changePercent24Hr,
           let changePercent = Double(changePercentString) {
            let formattedChangePercent = String(format: "%.2f%%", changePercent)
            let labelText = "\(NSLocalizedString("Price Change (24h)", comment: "")): "
            
            let fullText = labelText + formattedChangePercent
            let attributedString = NSMutableAttributedString(string: fullText)
            
            let valueRange = NSRange(location: labelText.count, length: formattedChangePercent.count)
            
            let color = changePercent >= 0 ? UIColor.systemGreen : UIColor.systemRed
            attributedString.addAttribute(.foregroundColor, value: color, range: valueRange)
            
            priceChangeLabel.attributedText = attributedString
        } else {
            priceChangeLabel.text = "Price Change (24h): N/A"
        }
        
        if cryptoAsset.explorer != nil {
            explorerButton.setTitle("More about \(cryptoAsset.name)", for: .normal)
            explorerButton.isHidden = false
        } else {
            explorerButton.isHidden = true
        }
    }
    
    // MARK: - Helper Methods
    private func formatNumber(_ number: Double, maximumFractionDigits: Int, useCurrencyStyle: Bool = false) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = useCurrencyStyle ? .currency : .decimal
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.minimumFractionDigits = maximumFractionDigits
        formatter.currencySymbol = "$"
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    // MARK: - Actions
    @IBAction func explorerButtonTapped(_ sender: Any) {
        guard let urlString = cryptoAsset?.explorer,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

