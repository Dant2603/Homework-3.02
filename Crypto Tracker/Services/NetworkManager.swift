//
//  NetworkManager.swift
//  Homework 3.02
//
//  Created by Мария Гетманская on 09.11.2024.
//

import UIKit

enum NetworkError: Error {
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                print("Failed to fetch image data from URL: \(url)")
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetchLogos(for cryptos: [Link], itemCompletion: @escaping (Int, UIImage?) -> Void, completion: @escaping () -> Void) {
        let totalCryptos = cryptos.count
        var completedRequests = 0
        
        for (index, crypto) in cryptos.enumerated() {
            fetchImage(from: crypto.logoURL) { result in
                DispatchQueue.main.async {
                    let logo: UIImage?
                    switch result {
                    case .success(let imageData):
                        logo = UIImage(data: imageData)
                    case .failure:
                        logo = UIImage(named: "Placeholder")
                        print("Failed to load logo for \(crypto.name). Using placeholder.")
                    }
                    
                    itemCompletion(index, logo)
                    completedRequests += 1
                    
                    if completedRequests == totalCryptos {
                        completion()
                    }
                }
            }
        }
    }
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                    print(error ?? "No error description")
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let dataModel = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataModel))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    func fetchCryptoData(for cryptos: [Link], defaultAssets: [CryptoAsset], itemCompletion: @escaping (Int, CryptoAsset) -> Void, completion: @escaping () -> Void) {
        let totalCryptos = cryptos.count
        var completedRequests = 0
        
        for (index, crypto) in cryptos.enumerated() {
            fetch(CryptoDataResponse.self, from: crypto.url) { result in
                DispatchQueue.main.async {
                    var asset = defaultAssets[index]
                    switch result {
                    case .success(let cryptoDataResponse):
                        if let firstCryptoAsset = cryptoDataResponse.data.first {
                            asset = firstCryptoAsset
                        } else {
                            print("No data for \(crypto.symbol), using default asset.")
                        }
                    case .failure(let error):
                        print("Failed to fetch data for \(crypto.symbol): \(error)")
                    }
                    
                    itemCompletion(index, asset)
                    completedRequests += 1
                    
                    if completedRequests == totalCryptos {
                        completion()
                    }
                }
            }
        }
    }
    
    
    
    func fetchAllCryptoData(for cryptos: [Link], defaultAssets: [CryptoAsset], itemCompletion: @escaping (Int, CryptoAsset, UIImage?) -> Void, completion: @escaping () -> Void) {
        let totalCryptos = cryptos.count
        var completedRequests = 0
        
        for (index, crypto) in cryptos.enumerated() {
            var asset = defaultAssets[index]
            var logo: UIImage?
            var dataLoaded = false
            var logoLoaded = false
            
            func checkCompletion() {
                if dataLoaded && logoLoaded {
                    itemCompletion(index, asset, logo)
                    completedRequests += 1
                    
                    if completedRequests == totalCryptos {
                        completion()
                    }
                }
            }
            
            fetchCryptoData(for: [crypto], defaultAssets: [asset]) { _, fetchedAsset in
                asset = fetchedAsset
                dataLoaded = true
                checkCompletion()
            } completion: {}
            
            fetchLogos(for: [crypto]) { _, fetchedLogo in
                logo = fetchedLogo
                logoLoaded = true
                checkCompletion()
            } completion: {}
        }
    }
    
    
}

