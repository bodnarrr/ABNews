//
//  NewsModel.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

enum NewsResult {
    case success([NewsEntity])
    case error(String)
}

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsEntity]
}

class NewsEntity: Object, BaseEntity {
    @objc dynamic var title: String = ""
    @objc dynamic var descript: String? = ""
    @objc dynamic var url: String? = ""
    @objc dynamic var content: String? = ""
    @objc dynamic var imagePath: String? = ""
    
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case title
        case descript = "description"
        case url
        case content
        case imagePath = "urlToImage"
    }
    
}

class NewsModel: BaseArrayEntityModel {
    typealias Entity = NewsEntity
    
    // MARK: - Properties
    var entity: Variable<[NewsEntity]> = Variable([])
    let disposeBag = DisposeBag()
    
    // MARK: - Realm
    let realm = try! Realm()
    
    // MARK: - Public
    func loadNews() -> Observable<NewsResult> {
        return APIManager.shared.loadNews()
            .do(onNext: { [weak self] in
                switch $0 {
                case .success(let news):
                    self?.saveNewsToRealm(news)
                case .error(let error):
                    print("~~~> Error from API: \(error)")
                }
            })
    }
    
    func loadLocalData() {
        let localNews = realm.objects(NewsEntity.self)
        if localNews.isEmpty {
            loadNews()
                .subscribe()
                .disposed(by: disposeBag)
        } else {
            let convertedNews = Array(localNews)
            entity.value = convertedNews
            APIManager.shared.updateCurrentPage(forExistingNews: convertedNews.count)
        }
    }
    
    func clearLocalStorage() {
        let localSavedNews = realm.objects(NewsEntity.self)
        try! realm.write {
            realm.delete(localSavedNews)
        }
        entity.value = []
    }
    
    // MARK: - Private
    func saveNewsToRealm(_ news: [NewsEntity]) {
        
        news.forEach { [weak self] element in
            guard let self = self else { return }
            let article = realm.objects(NewsEntity.self).filter("title = %@", element.title).first
            let existInRealm = article != nil
            if !existInRealm {
                try! realm.write {
                    realm.add(element)
                }
                self.entity.value.append(element)
            }
        }
    }
}
