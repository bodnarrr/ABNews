//
//  RootViewGettable.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import UIKit

public protocol RootViewGettable {
    
    associatedtype RootViewType
    
    var viewIfLoaded: UIView? { get }
    var rootView: RootViewType? { get }
}

public extension RootViewGettable {
    
    public var rootView: RootViewType? {
        return self.viewIfLoaded as? RootViewType
    }
}

