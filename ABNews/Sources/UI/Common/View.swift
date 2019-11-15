//
//  View.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import UIKit

class View: UIView {
    
    required init() {
        super.init(frame: .zero)
        
        fromNib()
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fromNib()
        prepare()
    }
    
    open func prepare() {}
}
