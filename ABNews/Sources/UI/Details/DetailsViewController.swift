//
//  DetailsViewController.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import Foundation
import RxSwift

class DetailsViewController: ViewController<DetailsView, DetailsViewModel, DetailsModel> {
    
    // MARK: - Properties
    var imageLoadingTask: URLSessionDataTask?
    
    // MARK: - LifeCycle
    override func viewWillDisappear(_ animated: Bool) {
        imageLoadingTask?.cancel()
    }
    
    // MARK: - Prepare
    override func prepareBindings() {
        super.prepareBindings()
        
        guard let view = rootView else { return }
        
        view.seeMoreButton.rx.tap.bind(to: viewModel.shouldSeeMore).disposed(by: disposeBag)
        
        viewModel.seeMore
            .withLatestFrom(viewModel.urlPath) { [weak self] (_, urlPath) in
                guard let self = self else { return }
                urlPath.map { self.navigateToBrowser($0) }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.content
            .bind(to: view.contentLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.imagePath
            .subscribe(onNext: { [weak self] in
                self?.imageLoadingTask = $0.flatMap { view.photoImageView.setCachedImage(urlString: $0) }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private
    private func navigateToBrowser(_ urlPath: String) {
        guard let url = URL(string: urlPath) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
