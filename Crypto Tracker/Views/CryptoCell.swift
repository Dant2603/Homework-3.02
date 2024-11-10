//
//  CryptoCell.swift
//  Homework 3.02
//
//  Created by Мария Гетманская on 08.11.2024.
//

import UIKit

import UIKit

final class CryptoCell: UICollectionViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!

    func configure(with cryptoAsset: CryptoAsset, color: UIColor, logo: UIImage?, placeholder: UIImage?) {
        nameLabel.text = cryptoAsset.name
        nameLabel.textColor = color
        priceLabel.text = "$\(String(format: "%.4f", Double(cryptoAsset.priceUsd) ?? 0.0))"

        if let change = Double(cryptoAsset.changePercent24Hr ?? "") {
            priceChangeLabel.text = "\(String(format: "%.2f", change))%"
            priceChangeLabel.textColor = change < 0 ? .red : .green
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
}



