//
//  CacheManager.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import Foundation
import UIKit

class CacheManager {
    
    static let shared = CacheManager()
    
    private var cache: NSCache<NSString, UIImage> = {
        let result = NSCache<NSString, UIImage>()
        
        return result
    }()
    
    private init() {}
    
    func cacheImage(urlString: String, completion: @escaping (UIImage?)->Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completion(nil)
            
            return nil
        }
        
        if let imageFromCache = cache.object(forKey: urlString as NSString) {
            completion(imageFromCache)
            
            return nil
        }
        
        let task: URLSessionDataTask = URLSession.shared
            .dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                if let dataResponse = data {
                    let imageToCache = UIImage(data: dataResponse)
                    if let image = imageToCache {
                        self.cache.setObject(image, forKey: urlString as NSString)
                    }
                    
                    DispatchQueue.main.async {
                        completion(imageToCache)
                    }
                }
        }
        
        task.resume()
        
        return task
    }
}

extension UIImageView {
    
    func setCachedImage(urlString: String) -> URLSessionDataTask? {
        return CacheManager.shared.cacheImage(urlString: urlString) { [weak self] (image) in
            self?.image = image
        }
    }
}
