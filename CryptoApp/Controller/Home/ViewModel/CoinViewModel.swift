
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
}
