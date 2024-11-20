//
//  CryptoDetailViewController.swift
//  Crypto Tracker
//
//  Created by Мария Гетманская on 10.11.2024.
//

import UIKit

final class CryptoDetailViewController: UIViewController {
    
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
    
    // MARK: - Properties
    var cryptoAsset: CryptoAsset?
    var logoImage: UIImage?
    
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
        
        setupPriceLabel()
        setupRankLabel()
        setupSupplyLabel()
        setupMaxSupplyLabel()
        setupMarketCapLabel()
        setupVolumeLabel()
        setupPriceChangeLabel()
        setupExplorerButton()
    }
    
    private func setupPriceLabel() {
        if let priceUsd = Double(cryptoAsset?.priceUsd ?? "") {
            priceLabel.text = formatCurrency(priceUsd)
        } else {
            priceLabel.text = NSLocalizedString("Price: N/A", comment: "Price not available")
        }
    }
    
    private func setupRankLabel() {
        if let rank = cryptoAsset?.rank {
            rankLabel.text = String(format: NSLocalizedString("Rank: %@", comment: ""), rank)
        } else {
            rankLabel.text = NSLocalizedString("Rank: N/A", comment: "")
        }
    }
    
    private func setupSupplyLabel() {
        if let supplyString = cryptoAsset?.supply,
           let supply = Double(supplyString) {
            let formattedSupply = formatNumber(supply, maximumFractionDigits: 0)
            supplyLabel.text = String(
                format: NSLocalizedString("Supply (in circulation): %@ %@", comment: "Supply label"),
                formattedSupply, cryptoAsset?.symbol ?? ""
            )
        } else {
            supplyLabel.text = NSLocalizedString("Supply (in circulation): N/A", comment: "Supply not available")
        }
    }
    
    private func setupMaxSupplyLabel() {
        if let maxSupplyString = cryptoAsset?.maxSupply,
           let maxSupply = Double(maxSupplyString) {
            let formattedMaxSupply = formatNumber(maxSupply, maximumFractionDigits: 0)
            maxSupplyLabel.text = String(
                format: NSLocalizedString("Max Supply: %@ %@", comment: "Max Supply label"),
                formattedMaxSupply, cryptoAsset?.symbol ?? ""
            )
        } else {
            maxSupplyLabel.text = NSLocalizedString("Max Supply: N/A", comment: "Max Supply not available")
        }
    }
    
    private func setupMarketCapLabel() {
        if let marketCapString = cryptoAsset?.marketCapUsd,
           let marketCap = Double(marketCapString) {
            let formattedMarketCap = formatCurrency(marketCap)
            marketCapLabel.text = String(
                format: NSLocalizedString("Market Capitalization: %@", comment: "Market Cap label"),
                formattedMarketCap
            )
        } else {
            marketCapLabel.text = NSLocalizedString("Market Capitalization: N/A", comment: "Market Cap not available")
        }
    }
    
    private func setupVolumeLabel() {
        if let volumeString = cryptoAsset?.volumeUsd24Hr,
           let volume = Double(volumeString) {
            let formattedVolume = formatCurrency(volume)
            volumeLabel.text = String(
                format: NSLocalizedString("24h Trading Volume: %@", comment: "Volume label"),
                formattedVolume
            )
        } else {
            volumeLabel.text = NSLocalizedString("24h Trading Volume: N/A", comment: "Volume not available")
        }
    }
    
    private func setupPriceChangeLabel() {
        if let changePercentString = cryptoAsset?.changePercent24Hr,
           let changePercent = Double(changePercentString) {
            let formattedChangePercent = formatPercentage(changePercent)
            let labelText = NSLocalizedString("Price Change (24h): ", comment: "Price Change label")
            let fullText = labelText + formattedChangePercent
            let attributedText = attributedString(
                fullText: fullText,
                valueText: formattedChangePercent,
                valueColor: changePercent >= 0 ? UIColor.systemGreen : UIColor.systemRed
            )
            priceChangeLabel.attributedText = attributedText
        } else {
            priceChangeLabel.text = NSLocalizedString("Price Change (24h): N/A", comment: "Price Change not available")
        }
    }
    
    private func setupExplorerButton() {
        if let explorerURL = cryptoAsset?.explorer, !explorerURL.isEmpty {
            let buttonTitle = String(
                format: NSLocalizedString("More about %@", comment: "Explorer button title"),
                cryptoAsset?.name ?? ""
            )
            explorerButton.setTitle(buttonTitle, for: .normal)
            explorerButton.isHidden = false
        } else {
            explorerButton.isHidden = true
        }
    }
    
    // MARK: - Helper Methods
    private func formatCurrency(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = "$"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    private func formatNumber(_ number: Double, maximumFractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    private func formatPercentage(_ number: Double) -> String {
        return String(format: "%.2f%%", number)
    }
    
    private func attributedString(fullText: String, valueText: String, valueColor: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText)
        let valueRange = (fullText as NSString).range(of: valueText)
        attributedString.addAttribute(.foregroundColor, value: valueColor, range: valueRange)
        return attributedString
    }
    
    // MARK: - Actions
    @IBAction func explorerButtonTapped(_ sender: Any) {
        guard let urlString = cryptoAsset?.explorer,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

