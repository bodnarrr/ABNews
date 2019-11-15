//
//  ViewController.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import UIKit
import RxSwift

class ViewController<V: View, ViewModel: SimpleViewModel, Model: BaseModel>: UIViewController, RootViewGettable {
    
    typealias RootViewType = V
    
    let disposeBag = DisposeBag()
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = V()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        prepareBindings()
    }
    
    open func initialSetup() {}
    open func prepare() {}
    open func prepareBindings() {}
}
