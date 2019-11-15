//
//  APIManager.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import Foundation
import RxSwift

private struct ErrorString {
    static let unknown = "Unknown Error"
    static let prepareRequest = "Request making Error"
    static let decoding = "Decoding Error"
    static let noData = "No Data in Response"
}

private struct APIKey {
    static let key = "34250400381146dfb1888a134c2cc9dc"
}

// MARK: -
class APIManager {
    
    // MARK: - Properties
    private var appleNewsUrlString = "https://newsapi.org/v2/everything?q=apple"
    
    private var session: URLSession {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.httpCookieAcceptPolicy = .never
        
        return URLSession(configuration: sessionConfiguration)
    }
    
    var currentPage = 1
    let pageSize = 20
    
    // MARK - Init/Deinit
    private init() {}
    static let shared = APIManager()
    
    // MARK: - Private
    private func prepareNewsRequest(page: Int) -> URLRequest? {
        let urlString = appleNewsUrlString + "&page=\(page)"
        guard let url = URL(string: urlString) else { return nil}
        
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        urlRequest.httpMethod = "GET"
        let headers = [
            "X-Api-Key": APIKey.key
        ]
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }
    
    // MARK: - Public
    func loadNews() -> Observable<NewsResult> {
        
        return Observable<NewsResult>.create { [weak self] observer in
            guard let self = self else {
                observer.onNext(.error(ErrorString.unknown))
                return Disposables.create()
            }
            
            guard let request = self.prepareNewsRequest(page: self.currentPage) else {
                observer.onNext(.error(ErrorString.prepareRequest))
                return Disposables.create()
            }
            
            let task = self.session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let value = data {
                    if let success = try? JSONDecoder().decode(NewsResponse.self, from: value) {
                        self.currentPage += 1
                        DispatchQueue.main.async {
                            observer.onNext(.success(success.articles))
                        }
                    } else {
                        DispatchQueue.main.async {
                            observer.onNext(.error(ErrorString.decoding))
                        }
                    }
                } else if let err = error {
                    DispatchQueue.main.async {
                        observer.onNext(.error(err.localizedDescription))
                    }
                }
            })
            
            task.resume()
            
            return Disposables.create()
        }
    }
    
    func updateCurrentPage(forExistingNews news: Int) {
        let loadedPages = news / pageSize
        currentPage += loadedPages
    }
}
