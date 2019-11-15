//
//  DetailsViewModel.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import Foundation
import RxSwift

class DetailsViewModel: BaseSingleModelViewModel<DetailsModel> {
    
    // MARK: - Properties
    let shouldSeeMore: AnyObserver<Void>
    let seeMore: Observable<Void>
    
    // MARK: - Computed
    var title: Observable<String> {
        return model.entity
            .asObservable()
            .map { $0.title }
    }
    
    var content: Observable<String?> {
        return model.entity
            .asObservable()
            .map { $0.content }
    }
    
    var imagePath: Observable<String?> {
        return model.entity
            .asObservable()
            .map { $0.imagePath }
    }
    
    var urlPath: Observable<String?> {
        return model.entity
            .asObservable()
            .map { $0.url }
    }
    
    // MARK: - Init
    override init(model: DetailsModel) {
        let seeMoreSignal = PublishSubject<Void>()
        shouldSeeMore = seeMoreSignal.asObserver()
        seeMore = seeMoreSignal.asObservable()
        
        super.init(model: model)
    }
}
