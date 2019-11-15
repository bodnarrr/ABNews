//
//  NewsViewModel.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class NewsViewModel: BaseSingleModelViewModel<NewsModel> {
    
    // MARK: - Properties
    let shouldRefresh: AnyObserver<Void>
    let refresh: Observable<Void>
    
    var news: Observable<[NewsEntity]> {
        return model.entity
            .asObservable()
    }
    
    var currentNewsCount: Int {
        return model.entity.value.count
    }
    
    // MARK: - Init
    override init(model: NewsModel) {
        let refreshSignal = PublishSubject<Void>()
        shouldRefresh = refreshSignal.asObserver()
        refresh = refreshSignal.asObservable()
        
        super.init(model: model)
    }
    
    // MARK: - Public
    func loadNews() -> Observable<NewsResult> {
        return model.loadNews()
    }
    
    func loadLocalData() {
        model.loadLocalData()
    }
    
    func needToFetchData(currentRow row: Int) -> Bool {
        return currentNewsCount - row < 6
    }
    
    func clearData() {
        model.clearLocalStorage()
    }
}
