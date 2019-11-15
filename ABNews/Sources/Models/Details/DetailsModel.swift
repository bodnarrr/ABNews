//
//  DetailsModel.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import Foundation
import RxSwift

class DetailsModel: BaseSingleEntityModel {
    typealias Entity = NewsEntity
    
    // MARK: - Properties
    var entity: Variable<NewsEntity>
    
    // MARK: - Init
    init(withEntity entity: NewsEntity) {
        self.entity = Variable<NewsEntity>(entity)
    }
}
