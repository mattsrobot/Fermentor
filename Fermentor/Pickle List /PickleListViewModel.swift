//
//  PickleListViewModel.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct PickleListItem {
    var title: String
    var subtitle: String
    var detail: String
}

enum PickleEvent {
    case fetching
    case error(Swift.Error)
    case completed
}

protocol PickleListModelable {
    
    var isRefreshing: BehaviorRelay<Bool> { get }
    var pickles: BehaviorRelay<[PickleListItem]> { get }
    
    func fetchPickes() -> Observable<PickleEvent>
    
    func selectPickle(at indexPath: IndexPath)
    
    init(context: Context, coordinator: Coordinating, service: PickleProviding)
    
}

final class PickleListViewModel : PickleListModelable {
    
    private(set) var isRefreshing = BehaviorRelay(value: false)
    private(set) var pickles = BehaviorRelay(value: [PickleListItem]())
    
    fileprivate let context: Context
    fileprivate let coordinator: Coordinating
    fileprivate let service: PickleProviding
    fileprivate let disposeBag = DisposeBag()
    
    init(context: Context, coordinator: Coordinating, service: PickleProviding) {
        self.context = context
        self.coordinator = coordinator
        self.service = service
        self.context.pickles.subscribe(onNext: { (pickles) in
            self.pickles.accept(pickles.map({ pickle in
                return PickleListItem(title: pickle.name,
                                      subtitle: pickle.usesVinegar ? "Uses Vinegar" : "Fermented",
                                      detail: "")
            }))
        }).disposed(by: disposeBag)
    }
   
    func selectPickle(at indexPath: IndexPath) {
        let pickle = self.context.pickles.value[indexPath.row]
        self.coordinator.display(pickle: pickle)
    }
    
    @discardableResult func fetchPickes() -> Observable<PickleEvent> {
        return service.fetchPickes().map { event -> PickleEvent in
            switch event {
            case .completed(let pickles):
                self.isRefreshing.accept(false)
                self.context.pickles.accept(pickles)
                return .completed
            case .error(let error):
                self.isRefreshing.accept(false)
                return .error(error)
            case .fetching:
                self.isRefreshing.accept(true)
                return .fetching
            }
        }.asObservable()
    }
}
