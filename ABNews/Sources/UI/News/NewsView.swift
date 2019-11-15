//
//  NewsView.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import UIKit

class NewsView: View {
    
    // MARK: - Outlets
    @IBOutlet weak var newsTableView: UITableView!
    
    // MARK: - Prepare
    override func prepare() {
        super.prepare()
        
        prepareTableView()
    }
    
    private func prepareTableView() {
        newsTableView.tableFooterView = UIView()
    }
}
