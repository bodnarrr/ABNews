//
//  UIView+Nib.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let contentView  = bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? T
        
        nil != contentView ? self.addSubview(contentView!) : nil
        
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        
        [contentView?.leftAnchor.constraint(equalTo: self.leftAnchor),
         contentView?.rightAnchor.constraint(equalTo: self.rightAnchor),
         contentView?.topAnchor.constraint(equalTo: self.topAnchor),
         contentView?.bottomAnchor.constraint(equalTo: self.bottomAnchor)]
            .forEach { $0?.isActive = true }
        
        return contentView
    }
}
