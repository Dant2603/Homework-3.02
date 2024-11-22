//
//  NetworkManager.swift
//  Homework 3.02
//
//  Created by Мария Гетманская on 09.11.2024.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case noData
    case decodingError
}

final class NetworkManager {
    
    // MARK: - Properties
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Image Fetching
    func fetchImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data else {
                print("Failed to fetch image data from URL: \(url)")
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    
    // MARK: - Data Fetching
    func fetch<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                print(error ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let dataModel = try decoder.decode(T.self, from: data)
                completion(.success(dataModel))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchCryptoData(for crypto: Link, completion: @escaping (Result<CryptoAsset, NetworkError>) -> Void) {
        AF.request(crypto.url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let dataArray = json["data"] as? [[String: Any]],
                       let firstData = dataArray.first,
                       let cryptoAsset = CryptoAsset(json: firstData) {
                        completion(.success(cryptoAsset))
                    } else {
                        print("Failed to parse JSON for \(crypto.symbol)")
                        completion(.failure(.decodingError))
                    }
                case .failure(let error):
                    print("Error fetching data for \(crypto.symbol): \(error)")
                    completion(.failure(.noData))
                }
            }
    }
    
    // MARK: - Combined Data and Logo Fetching
    func fetchAllCryptoData(completion: @escaping ([Link: CryptoData]) -> Void) {
        let cryptos = Link.allCases
        var results: [Link: CryptoData] = [:]
        var completedRequests = 0
        
        for (_, crypto) in cryptos.enumerated() {
            var asset: CryptoAsset?
            var imageData: Data?
            
            // Flags to track loading of data and image
            var assetLoaded = false
            var imageLoaded = false
            
            // Closure to check if both data and image have been loaded
            func checkCompletion() {
                if assetLoaded && imageLoaded {
                    let cryptoData = CryptoData(asset: asset!, imageData: imageData)
                    results[crypto] = cryptoData
                    completedRequests += 1
                    if completedRequests == cryptos.count {
                        completion(results)
                    }
                }
            }
            
            fetchCryptoData(for: crypto) { result in
                switch result {
                case .success(let fetchedAsset):
                    asset = fetchedAsset
                case .failure(_):
                    asset = crypto.defaultAsset
                }
                assetLoaded = true
                checkCompletion()
            }
            
            fetchImage(from: crypto.logoURL) { result in
                switch result {
                case .success(let fetchedImageData):
                    imageData = fetchedImageData
                case .failure(_):
                    imageData = nil
                }
                imageLoaded = true
                checkCompletion()
            }
            
        }
    }
}

