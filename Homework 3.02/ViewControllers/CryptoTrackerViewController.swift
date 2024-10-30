//
//  MainViewController.swift
//  Homework 3.02
//
//  Created by Мария Гетманская on 30.10.2024.
//

import UIKit

final class CryptoTrackerViewController: UIViewController {
    
    @IBAction private func cryptoButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            fetchCryptoData(for: "BTC")
        case 2:
            fetchCryptoData(for: "ETH")
        default:
            fetchCryptoData(for: "USDT")
        }
    }
    
    private func fetchCryptoData(for cryptoId: String) {
        let urlString = "https://api.coincap.io/v2/assets?search=\(cryptoId)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let cryptoDataResponse = try JSONDecoder().decode(CryptoDataResponse.self, from: data)
                print(cryptoDataResponse.data.first!)
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

