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
    
    init(viewModel: PickleListModelable)
    
    func bindTo(viewModel: PickleListModelable)
}

fileprivate struct Constants {
    static let itemIdentifier = String(describing: PickleListItemView.self)
    static let rowHeight = CGFloat(100)
}

final class PickleListView : UIViewController, PickleListViewable {

    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
    @IBOutlet weak var emptyListLabel: UILabel!
    
    fileprivate let viewModel: PickleListModelable
    fileprivate let disposeBag = DisposeBag()
    
    init(viewModel: PickleListModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(viewModel:)")
    }
    
    func bindTo(viewModel: PickleListModelable) {
        
        viewModel.title
            .asObservable()
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.emptyListText
            .asObservable()
            .bind(to: emptyListLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isRefreshing
            .asObservable()
            .bind(to: activityIndicatorView!.rx.isAnimating)
            .disposed(by: disposeBag)
        
        let pickles = viewModel.pickles.asObservable()
        
        pickles
            .map({ $0.count > 0 })
            .bind(to: self.emptyListLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
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
            .bind(to: viewModel.selectedPickle)
            .disposed(by: disposeBag)
        
    }
    
    fileprivate func setupViews() {
        collectionView?.delegate = self
        collectionView?.registerPickleViews()
    }
    
    fileprivate func fetchPickles() {
        viewModel.fetchPickles
            .asObservable()
            .subscribe(onNext: { event in
                switch event {
                case .fetching:
                    print("Fetching pickles, have a ☕")
                case .completed(let count):
                    print("Got \(count) pickles 🥒🥒🥒")
                case .error(_):
                    print("🔥 Encountered an error fetching pickles 🔥")
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindTo(viewModel: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        return CGSize(width: collectionView.frame.width, height: Constants.rowHeight)
    }
    
}
