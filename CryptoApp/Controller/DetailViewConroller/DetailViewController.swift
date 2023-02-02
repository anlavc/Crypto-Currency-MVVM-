//
//  DetailViewController.swift
//  CryptoApp
//
//  Created by Anıl AVCI on 29.01.2023.
//

import UIKit
import SDWebImageSVGCoder

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var hightLabel: UILabel!
    @IBOutlet weak var totalChangeLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    
    var model: CoinListViewModel!
    var selectedCrypto: Coin?
    var selectedCoin: Coin?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let min = selectedCrypto?.sparkline?.min() {
            lowLabel.text = min.currencyFormatting()
        }
        if let max = selectedCrypto?.sparkline?.max() {
            hightLabel.text = max.currencyFormatting()
        }
        let change = Double(selectedCrypto?.change ?? "-") ?? 0.0
        //Calculate totolchange price * (change/100)
        if let priceInt = Double(selectedCrypto?.price! ?? "") {
            let priceChange = priceInt * (change / 100)
            let priceformat = priceChange.description.currencyFormatting()
            totalChangeLabel.text = "($\(priceformat))"
        }
        //Color
        if change > 0 {
            changeLabel.textColor = UIColor.systemGreen
            totalChangeLabel.textColor = UIColor.systemGreen
            
        } else if change < 0 {
            changeLabel.textColor = UIColor.systemRed
            totalChangeLabel.textColor = UIColor.systemRed
            
        } else {
            changeLabel.textColor = UIColor.systemYellow
            totalChangeLabel.textColor = UIColor.systemYellow
            
        }
        //Image
        let url = URL(string: selectedCrypto?.iconURL ?? "")
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        if (selectedCrypto?.iconURL) != nil {
            bgImage.sd_setImage(with: url, completed: nil)
        } else {
            bgImage.image = UIImage(named: "splash")
        }
        changeLabel.text = "\(selectedCrypto?.change ?? "")%"
        priceLabel.text = "$\(selectedCrypto?.price?.currencyFormatting() ?? "")"
        //NavigatonController
        navigationItem.prompt = selectedCrypto?.symbol
        navigationItem.title = selectedCrypto?.name
        //        let color = model?.hexStringToUIColor(hex: selectedCrypto?.color ?? "")
        view.backgroundColor = UIColor.systemGray6
    }
    /// WkWebView
    /// - Parameters:
    ///   - segue: URL Segue
    ///   - sender: UIButton
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coinUrl = selectedCrypto?.coinrankingURL
        let destinationVC = segue.destination as! WebViewController
        destinationVC.coinUrl = coinUrl
    }
}

