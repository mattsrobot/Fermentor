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
    
    init(viewModel: PickleListModelable, style: PickleListStyle)
    
    func bindTo(viewModel: PickleListModelable)
}

fileprivate struct Constants {
    static let itemIdentifier = String(describing: PickleListItemView.self)
    static let colorFlipDuration = TimeInterval(1)
}

final class PickleListView : UIViewController, PickleListViewable {

    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
    @IBOutlet weak var emptyListLabel: UILabel?
    fileprivate let viewModel: PickleListModelable
    fileprivate let style: PickleListStyle
    fileprivate let disposeBag = DisposeBag()
    
    init(viewModel: PickleListModelable, style: PickleListStyle) {
        self.viewModel = viewModel
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(viewModel:)")
    }
    
    func bindTo(viewModel: PickleListModelable) {
        
        guard let collectionView = collectionView,
              let emptyListLabel = emptyListLabel,
              let activityIndicatorView = activityIndicatorView else {
            return
        }
                
        var animated = false
        style.listViewBackgroundColor
            .subscribe(onNext: { color in
                UIView.setLayersBackground([self.view.layer, collectionView.layer],
                                           to: color.cgColor,
                                           animated: animated,
                                           duration: Constants.colorFlipDuration)
                animated = true
            })
            .disposed(by: disposeBag)
        
        style.listViewBackgroundColor
            .bind(to: (collectionView as UIView).rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.title
            .asObservable()
            .throttle(1, scheduler: MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.emptyListText
            .asObservable()
            .bind(to: emptyListLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isRefreshing
            .asObservable()
            .throttle(1, scheduler: MainScheduler.instance)
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        let pickles = viewModel.pickleListItems.asObservable()
        
        pickles
            .map({ $0.count > 0 })
            .bind(to: emptyListLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        pickles
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.itemIdentifier,
                                                              for: indexPath) as! PickleListItemView
                cell.configure(with: element)
                return cell
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asObservable()
            .bind(to: viewModel.selectedPickle)
            .disposed(by: disposeBag)
        
    }
    
    fileprivate func setupToolbar() {
        
        let viewModel = self.viewModel
        let disposeBag = self.disposeBag
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)
        
        composeButton.rx.tap.subscribe(onNext: {
            viewModel
                .composePickle
                .subscribe(onNext: { event in
                    
                })
                .disposed(by: disposeBag)
        }).disposed(by: disposeBag)
        
        setToolbarItems([flexibleSpace,composeButton],
                        animated: true)
        
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    fileprivate func setupViews() {
        collectionView?.registerPickleViews()
        setupToolbar()
    }
    
    fileprivate func fetchPickles() {
        viewModel.fetchPickles
            .asObservable()
            .subscribe(onNext: { event in
                switch event {
                case .fetching:
                    Log.debug("Fetching pickles, have a ☕")
                case .completed(let count):
                    Log.debug("Got \(count) pickles 🥒🥒🥒")
                case .error(_):
                    Log.failure("Encountered an error fetching pickles")
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindTo(viewModel: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        return CGSize(width: collectionView.frame.width, height: style.itemHeight)
    }
    
}
