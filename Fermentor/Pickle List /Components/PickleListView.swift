//
//  PickleListView.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PickleListViewable {
    
    var view: UIView! { get }
    var collectionView: UICollectionView? { get }
    
    init(viewModel: PickleListModelable, coordinator: Coordinating)
    
    func bindTo(viewModel: PickleListModelable)
}

fileprivate struct Constants {
    static let itemIdentifier = String(describing: PickleListItemView.self)
}

final class PickleListView : UIViewController, PickleListViewable {

    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
  
    fileprivate let viewModel: PickleListModelable
    fileprivate let coordinator: Coordinating
    fileprivate let disposeBag = DisposeBag()
    
    init(viewModel: PickleListModelable, coordinator: Coordinating) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(viewModel:,coordinator:)")
    }
    
    func bindTo(viewModel: PickleListModelable) {
        
        let isRefreshing = viewModel.isRefreshing.asObservable()
        
        isRefreshing
            .bind(to: activityIndicatorView!.rx.isAnimating)
            .disposed(by: disposeBag)
        
        let pickles = viewModel.pickles.asObservable()
        
        pickles
            .bind(to: collectionView!.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = self.collectionView!.dequeueReusableCell(withReuseIdentifier: Constants.itemIdentifier,
                                                                    for: indexPath) as! PickleListItemView
                cell.configure(with: element)
                return cell
            }
            .disposed(by: disposeBag)
        
        
        collectionView!.rx.itemSelected.asObservable()
            .bind { indexPath in
                viewModel.selectPickle(at: indexPath)
            }
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupViews() {
        collectionView?.delegate = self
        collectionView?.registerPickleViews()
    }
    
    fileprivate func fetchPickles() {
        viewModel.fetchPickes().bind { _ in
            
        }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindTo(viewModel: viewModel)
        fetchPickles()
    }

}

fileprivate extension UICollectionView {
    
    func registerPickleViews() {
        let item = String(describing: PickleListItemView.self)
        register(UINib.init(nibName: item, bundle: nil), forCellWithReuseIdentifier: item)
    }
    
}

extension PickleListView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
}
