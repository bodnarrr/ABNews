//
//  BaseModel.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import Foundation
import RxSwift

protocol BaseEntity: Equatable, Codable {}

protocol BaseModel: class {}

protocol BaseSingleEntityModel: BaseModel {
    associatedtype Entity: BaseEntity
    
    var entity: Variable<Entity> { get }
}

protocol BaseArrayEntityModel: BaseModel {
    associatedtype Entity: BaseEntity
    
    var entity: Variable<[Entity]> { get }
}
