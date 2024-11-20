//
//  CryptoTrackerViewController.swift
//  Homework 3.02
//
//  Created by Мария Гетманская on 07.11.2024.
//

import UIKit

// MARK: - CryptoTrackerViewController
final class CryptoTrackerViewController: UICollectionViewController {
    
    // MARK: - Properties
    private let networkManager = NetworkManager.shared
    private var cryptoDataDict: [Link: CryptoData] = [:]
    private let placeholderImage = UIImage(named: "Placeholder")
    private let refreshControl = UIRefreshControl()
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupRefreshControl()
        fetchCryptoData()
        navigationItem.title = "Crypto Tracker"
        navigationItem.backButtonTitle = "Back"
        collectionView.allowsSelection = true
    }
    
    // MARK: - Setup Methods
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
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
        return Link.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CryptoCell", for: indexPath)
        guard let cell = cell as? CryptoCell else { return UICollectionViewCell() }
        
        let crypto = Link.allCases[indexPath.item]
        let cryptoData = cryptoDataDict[crypto] ?? CryptoData(asset: crypto.defaultAsset, imageData: nil)
        
        let logoImage = UIImage(data: cryptoData.imageData ?? Data()) ?? placeholderImage
        
        // Check if crypto asset data is loaded
        let isEnabled = isDataLoaded(for: cryptoData.asset)
        
        cell.configure(
            with: cryptoData.asset,
            color: CryptoAppearance.color(for: crypto),
            logo: logoImage,
            placeholder: placeholderImage
        )
        cell.updateAppearance(isEnabled: isEnabled)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let crypto = Link.allCases[indexPath.item]
        if let cryptoData = cryptoDataDict[crypto] {
            return isDataLoaded(for: cryptoData.asset)
        }
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailSegue", sender: indexPath)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue",
           let detailVC = segue.destination as? CryptoDetailViewController,
           let indexPath = sender as? IndexPath {
            
            let crypto = Link.allCases[indexPath.item]
            let cryptoData = cryptoDataDict[crypto] ?? CryptoData(asset: crypto.defaultAsset, imageData: nil)
            let logoImage = cryptoData.imageData.flatMap { UIImage(data: $0) } ?? placeholderImage
            
            detailVC.cryptoAsset = cryptoData.asset
            detailVC.logoImage = logoImage
        }
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
    private func isDataLoaded(for cryptoAsset: CryptoAsset) -> Bool {
        return cryptoAsset.priceUsd != "N/A"
    }
}

// MARK: - Networking
extension CryptoTrackerViewController {
    @objc private func fetchCryptoData() {
        if !refreshControl.isRefreshing {
            activityIndicator.startAnimating()
        }
        
        // Clear current data
        cryptoDataDict = [:]
        collectionView.reloadData()
        
        networkManager.fetchAllCryptoData { [weak self] cryptoDataDict in
            guard let self else { return }
            
            DispatchQueue.main.async {
                // Update data and reload collection view
                self.cryptoDataDict = cryptoDataDict
                self.collectionView.reloadData()
                
                self.activityIndicator.stopAnimating()
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
}
