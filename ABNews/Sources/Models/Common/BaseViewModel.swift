//
//  BaseViewModel.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import Foundation

class SimpleViewModel {}

class BaseViewModel<Model: BaseModel>: SimpleViewModel {}

class BaseSingleModelViewModel<Model: BaseModel>: BaseViewModel<Model> {
    
    var model: Model
    
    init(model: Model) {
        self.model = model
        
        super.init()
        
        prepareBindings()
    }
    
    func prepareBindings() {}
}
