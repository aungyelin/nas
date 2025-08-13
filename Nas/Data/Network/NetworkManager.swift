//
//  NetworkManager.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "https://saurav.tech"
    
    
    private func request<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) -> Single<T> {
        return Single.create { single in
            let request = AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value): single(.success(value))
                    case .failure(_): single(.failure(NetworkError(message: response.error?.localizedDescription ?? "Network Error")))
                    }
                }
            return Disposables.create { request.cancel() }
        }
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) -> Single<T> {
        let fullURL = baseURL + endpoint
        
        return self.request(
            url: fullURL,
            method: method,
            parameters: parameters,
            headers: headers
        )
    }
    
}
