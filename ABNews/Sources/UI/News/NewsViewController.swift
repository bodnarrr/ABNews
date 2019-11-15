//
//  NewsViewController.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class NewsViewController: ViewController<NewsView, NewsViewModel, NewsModel>, UITableViewDelegate {
    
    // MARK: - Properties
    var tableViewRefreshControl: UIRefreshControl?
    
    // MARK: - Prepare
    override func prepare() {
        super.prepare()
        
        guard let view = rootView else { return }
        navigationItem.title = "AB News"
        
        view.newsTableView.registerCell(NewsCell.self)
        view.newsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        preparePullToRefresh()
        
        viewModel.loadLocalData()
        
        viewModel.news
            .bind(to: view.newsTableView.rx.items) { [weak self] (tv, row, item) -> UITableViewCell in
                guard let self = self else { return UITableViewCell() }
                if self.viewModel.needToFetchData(currentRow: row) {
                    self.viewModel.loadNews()
                        .subscribe()
                        .disposed(by: self.disposeBag)
                }
                
                let cell = tv.dequeueReusableCell(withIdentifier: "NewsCell", for: IndexPath(row: row, section: 0)) as! NewsCell
                cell.fillWithModel(item)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        view.newsTableView
            .rx
            .modelSelected(NewsEntity.self)
            .subscribe(onNext: { [weak self] entity in
                guard let self = self else { return }
                self.showDetails(forEntity: entity)
            })
            .disposed(by: disposeBag)
        
        viewModel.refresh
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.refreshData()
            })
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Private
    private func preparePullToRefresh() {
        guard let view = rootView else { return }
        let refreshControl = UIRefreshControl()
        view.newsTableView.refreshControl = refreshControl
        self.tableViewRefreshControl = refreshControl
        
        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.shouldRefresh).disposed(by: disposeBag)
    }
    
    private func refreshData() {
        viewModel.clearData()
        APIManager.shared.currentPage = 1
        viewModel.loadNews()
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.tableViewRefreshControl.map { $0.endRefreshing() }
            })
            .disposed(by: disposeBag)
    }
    
    private func showDetails(forEntity entity: NewsEntity) {
        let model = DetailsModel(withEntity: entity)
        let viewModel = DetailsViewModel(model: model)
        let controller = DetailsViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
