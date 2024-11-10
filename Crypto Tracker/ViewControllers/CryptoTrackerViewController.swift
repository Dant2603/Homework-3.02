//
//  CryptoTrackerViewController.swift
//  Homework 3.02
//
//  Created by Мария Гетманская on 07.11.2024.
//

import UIKit

// MARK: - Constants
private let baseURL = "https://api.coincap.io/v2/assets?search="
private let logoBaseURL = "https://static.coinpaprika.com/coin/"

// MARK: - Link Enum
enum Link: CaseIterable {
    case bitcoin
    case ethereum
    case tether
    case litecoin
    case ripple
    case cardano
    case solana
    case dogecoin

    var name: String {
        switch self {
        case .bitcoin: return "Bitcoin"
        case .ethereum: return "Ethereum"
        case .tether: return "Tether"
        case .litecoin: return "Litecoin"
        case .ripple: return "Ripple"
        case .cardano: return "Cardano"
        case .solana: return "Solana"
        case .dogecoin: return "Dogecoin"
        }
    }

    var symbol: String {
        switch self {
        case .bitcoin: return "BTC"
        case .ethereum: return "ETH"
        case .tether: return "USDT"
        case .litecoin: return "LTC"
        case .ripple: return "XRP"
        case .cardano: return "ADA"
        case .solana: return "SOL"
        case .dogecoin: return "DOGE"
        }
    }

    private var apiID: String {
        switch self {
        case .bitcoin: return "btc-bitcoin"
        case .ethereum: return "eth-ethereum"
        case .tether: return "usdt-tether"
        case .litecoin: return "ltc-litecoin"
        case .ripple: return "xrp-xrp"
        case .cardano: return "ada-cardano"
        case .solana: return "sol-solana"
        case .dogecoin: return "doge-dogecoin"
        }
    }

    var color: UIColor {
        switch self {
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

    var url: URL {
        return URL(string: baseURL + symbol)!
    }

    var logoURL: URL {
        return URL(string: "\(logoBaseURL)\(self.apiID)/logo.png")!
    }
}

// MARK: - CryptoTrackerViewController
final class CryptoTrackerViewController: UICollectionViewController {
    
    // MARK: - Properties
    private let networkManager = NetworkManager.shared
    private var cryptoAssets: [CryptoAsset] = []
    private var logos: [UIImage?] = []
    private let placeholderImage = UIImage(named: "Placeholder")
    private let refreshControl = UIRefreshControl()
    private var activityIndicator: UIActivityIndicatorView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Crypto Tracker"
        setupActivityIndicator()
        setupRefreshControl()
        fetchCryptoData()
    }

    // MARK: - Setup Methods
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshCryptoData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    // MARK: - Actions
    @objc private func refreshCryptoData() {
        fetchCryptoData()
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cryptoAssets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CryptoCell", for: indexPath)
        guard let cell = cell as? CryptoCell else { return UICollectionViewCell() }

        let cryptoAsset = cryptoAssets[indexPath.item]
        let crypto = Link.allCases[indexPath.item]
        let logo = logos[indexPath.item] ?? placeholderImage

        cell.configure(with: cryptoAsset, color: crypto.color, logo: logo, placeholder: placeholderImage)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CryptoTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 48
        let height = UIScreen.main.bounds.height / 3 - 68
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 26
    }
}

// MARK: - Helper Methods
extension CryptoTrackerViewController {
    func createDefaultAssets() -> [CryptoAsset] {
        return Link.allCases.map { link in
            CryptoAsset(
                name: "\(link.name) (Unavailable)",
                symbol: link.symbol,
                priceUsd: "N/A",
                changePercent24Hr: "N/A"
            )
        }
    }
}

// MARK: - Networking
extension CryptoTrackerViewController {
    private func fetchCryptoData() {
        DispatchQueue.main.async {
            if !self.refreshControl.isRefreshing {
                self.activityIndicator.startAnimating()
            }
        }

        self.cryptoAssets = self.createDefaultAssets()
        self.logos = Array(repeating: self.placeholderImage, count: self.cryptoAssets.count)
        self.collectionView.reloadData()

        networkManager.fetchAllCryptoData(for: Link.allCases, defaultAssets: self.cryptoAssets, itemCompletion: { [weak self] index, asset, logo in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.cryptoAssets[index] = asset
                self.logos[index] = logo
                let indexPath = IndexPath(item: index, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
            }
        }, completion: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                }
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
        })
    }

}
