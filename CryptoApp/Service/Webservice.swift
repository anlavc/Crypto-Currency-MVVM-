//
//  Webservice.swift
//  bundleApp
//
//  Created by Anıl AVCI on 13.07.2022.
//

import Foundation

protocol APICallerProtocol {
    func fetch<T: Codable>(response: T.Type, with path: APICall, completion: @escaping(Result<T, Error>) -> Void)
}

final class APICaller: APICallerProtocol {
    func fetch<T:Codable>(response: T.Type, with path: APICall, completion: @escaping (Result<T, Error>) -> Void) {
        let request = URLRequest(url: path.url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print("Error!")
                return
            }
            guard let data = data else {
                completion(.failure(WebError.dataNotFound))
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let response = try jsonDecoder.decode(T.self, from: data)
                completion(.success(response))
            } catch  {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

protocol APICallServiceProtocol {
    func getCrypto(completion: @escaping(Result<Currencies, Error>)-> Void)
}

final class APICallService: APICallServiceProtocol {
    private let service: APICallerProtocol
    init(service: APICallerProtocol) {
        self.service = service
    }
    func getCrypto(completion: @escaping (Result<Currencies, Error>) -> Void) {
        service.fetch(response: Currencies.self, with: .getCryptos, completion: completion)
    }
}

enum WebError: Error {
    case dataNotFound
}


