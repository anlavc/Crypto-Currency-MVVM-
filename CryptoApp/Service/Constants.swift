//
//  Constants.swift
//  CryptoApp
//
//  Created by Anıl AVCI on 29.01.2023.
//

import Foundation


//enum CoinAPICall: String{
//
//    case getCoins
//
//    private var urlString: String {
//        switch self {
//        case .getCoins:
//            return "https://psp-merchantpanel-service-sandbox.ozanodeme.com.tr/api/v1/dummy/coins"
//        }
//    }
//    var url: URL{
//        switch self {
//        case .getCoins:
//            return URL(string: urlString)!
//        }
//    }
//}

import Foundation

enum APICall: String {
    case getCryptos
    
    private var urlString: String {
        switch self {
        case .getCryptos:
            return "https://psp-merchantpanel-service-sandbox.ozanodeme.com.tr/api/v1/dummy/coins"
        }
    }
    
    var url: URL {
        switch self {
        case .getCryptos:
            return URL(string: urlString)!
        }
    }
}
