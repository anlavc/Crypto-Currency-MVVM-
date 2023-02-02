
import Foundation
import UIKit


final class CoinListViewModel {
    var selectedCrypto: Coin?
    var mainArray: [Coin] = []     // Response incoming
    var filtered: [Coin] = []      // Search result temporary
    var coinArray: [Coin] = []     // Show user array
    private let APIService: APICallService
    
    init(APIService: APICallService) {
        self.APIService = APIService
    }

}
extension CoinListViewModel {
    var numberOfSections: Int {
        return 1
    }
    
    func getCrypto(completionHandler: @escaping () -> Void) {
        APIService.getCrypto { result in
            switch result {
            case .success(let response):
                if let cryptos = response.data {
                    self.mainArray = cryptos.coins ?? []
                    self.coinArray = self.mainArray
                }
                
                completionHandler()
            case .failure(let error):
                print(error)
            }
        }
    }
//    func numberOfRowsSection(_ section: Int) -> Int {
//        return coinArray.count
//    }
//    func coinAtIndex(_ index: Int) -> CoinViewModel {
//        let article = self.coinArray[index]
//        return CoinViewModel(article)
//    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}


// 1. kısım

struct CoinViewModel {
    private let article: Coin
}

extension CoinViewModel {
    init(_ article: Coin) {
        self.article = article
    }
}

extension CoinViewModel {
    var uuid: String? {
        return self.article.uuid
    }
    var symbol: String? {
        return self.article.symbol
    }
    var name: String? {
        return self.article.name
    }
    var color: String? {
        return self.article.color
    }
    var iconUrl: String? {
        
        return self.article.iconURL
    }
    var price: String? {
        return self.article.price
    }
    var listedAt: Int? {
        return self.article.listedAt
    }
    var sparkline: [String]? {
        return self.article.sparkline
    }
    var lowVolume: Bool? {
        return self.article.lowVolume
    }
    var volume24: String? {
        return self.article.the24HVolume
    }
    var btcprice: String? {
        return self.article.btcPrice
    }
    var change: String? {
        return self.article.change
    }
}
