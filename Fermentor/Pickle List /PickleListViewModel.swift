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

/// A view model describing a pickle to be displayed in a list view
struct PickleListItem {
    var title: String
    var subtitle: String
    var detail: String
}

/// An event associated to the pickle list
///
/// - fetching: you attempt to fetch more pickles
/// - error: an error occured
/// - completed: a pickle fetch has completed
enum PickleEvent {
    case fetching
    case error(Swift.Error)
    case completed(Int)
}

/// A View Model describing a Pickle List
protocol PickleListModelable {
    /// The title of the screen
    var title: BehaviorRelay<String> { get }
    // The text of empty list label
    var emptyListText: BehaviorRelay<String> { get }
    /// If the list is refreshing
    var isRefreshing: BehaviorRelay<Bool> { get }
    /// A list of pickle view models
    var pickles: BehaviorRelay<[PickleListItem]> { get }
    /// Fetches pickles, returns a pickle event stream
    var fetchPickles: Observable<PickleEvent> { get }
    /// The selected pickle index path
    var selectedPickle: BehaviorRelay<IndexPath?> { get }
    /// The initializer for PickleListModelable
    ///
    /// - Parameters:
    ///   - workspace: the current workspace for data
    ///   - coordinator: the coordinator for navigation
    ///   - service: a pickle providing service
    init(workspace: Workspace, coordinator: Coordinating, service: PickleProviding)
}

final class PickleListViewModel : PickleListModelable {

    private(set) var title = BehaviorRelay(value: "Pickle List")
    private(set) var emptyListText = BehaviorRelay(value: "You have no 🥒")
    private(set) var isRefreshing = BehaviorRelay(value: false)
    private(set) var pickles = BehaviorRelay(value: [PickleListItem]())
    private(set) var selectedPickle:BehaviorRelay<IndexPath?> = BehaviorRelay(value: nil)
    fileprivate let workspace: Workspace
    fileprivate let coordinator: Coordinating
    fileprivate let service: PickleProviding
    fileprivate let disposeBag = DisposeBag()
    
    var fetchPickles: Observable<PickleEvent> {
        return service.fetchPickes().map { event -> PickleEvent in
            switch event {
            case .completed(let pickles):
                self.isRefreshing.accept(false)
                self.workspace.pickles.accept(pickles)
                return .completed(pickles.count)
            case .error(let error):
                self.isRefreshing.accept(false)
                return .error(error)
            case .fetching:
                self.isRefreshing.accept(true)
                return .fetching
            }
            }.asObservable()
    }
    
    init(workspace: Workspace, coordinator: Coordinating, service: PickleProviding) {
        
        self.workspace = workspace
        self.coordinator = coordinator
        self.service = service
        
        isRefreshing
            .map({ $0 ? "Refreshing" : "Pickle List" })
            .bind(to: self.title)
            .disposed(by: disposeBag)
        
        workspace.pickles
            .asObservable()
            .map({
                $0.map({PickleListItem(title: $0.name,
                                       subtitle: $0.usesVinegar ? "Uses Vinegar" : "Fermented",
                                       detail: "")})})
            .bind(to: self.pickles)
            .disposed(by: disposeBag)
        
        selectedPickle
            .asObservable()
            .subscribe(onNext: { selectedPickle in
                guard let selectedPickle = selectedPickle else {
                    return
                }
                self.coordinator.display(pickle: self.workspace.pickles.value[selectedPickle.row])
            })
            .disposed(by: disposeBag)
    }

}