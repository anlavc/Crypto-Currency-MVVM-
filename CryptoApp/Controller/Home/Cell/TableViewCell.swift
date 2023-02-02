//
//  TableViewCell.swift
//  Crypto Currency
//
//  Created by Anıl AVCI on 27.01.2023.
//

import UIKit
import SDWebImageSVGCoder

class TableViewCell: UITableViewCell {
    public var coinListVM:CoinListViewModel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cryptoName: UILabel!
    @IBOutlet weak var cryptoShortName: UILabel!
    @IBOutlet weak var currencyIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 10
        cellView.layer.masksToBounds = true
        
    }
    func setup(coins: Coin) {
        let color = coins.color?.hexStringToUIColor()
        cryptoShortName.text = coins.symbol
        cryptoName.text = coins.name
        cryptoName.textColor = color
        let coinPrice = coins.price?.currencyFormatting()
        price.text = "$\(coinPrice ?? "")"
        let change = Double(coins.change!) ?? 0.0
        if change > 0 {
            changeLabel.textColor = UIColor.systemGreen
            label2.textColor = UIColor.systemGreen
        } else if change < 0 {
            changeLabel.textColor = UIColor.systemRed
            label2.textColor = UIColor.systemRed
        } else {
            changeLabel.textColor = UIColor.systemYellow
            label2.textColor = UIColor.systemYellow
        }
        if change > 0 {
            changeLabel.textColor = UIColor.systemGreen
            label2.textColor = UIColor.systemGreen
            
        } else if change < 0 {
            changeLabel.textColor = UIColor.systemRed
            label2.textColor = UIColor.systemRed
        } else {
            changeLabel.textColor = UIColor.systemYellow
            label2.textColor = UIColor.systemYellow
        }
        if let priceInt = Double(coins.price!) {
            let priceChange = priceInt * (change / 100)
            let priceformat = priceChange.description.currencyFormatting()
            label2.text = "($\(priceformat))"
        }
        changeLabel.text = "\(change)% "
        //Image
        let url = URL(string: coins.iconURL ?? "")
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        if let imgUrl = (url) {
            currencyIcon.sd_setImage(with: imgUrl, completed: nil)
        } else {
            currencyIcon.image =  UIImage(named: "splash")
        }
        selectionStyle = .none
    }
}
