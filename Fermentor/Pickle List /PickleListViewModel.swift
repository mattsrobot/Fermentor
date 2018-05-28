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
    
    init(pickle: Pickle) {
        title = pickle.name
        subtitle = pickle.usesVinegar ? LocalizedStrings.PickleListScreen.Item.pickled :
                                        LocalizedStrings.PickleListScreen.Item.fermented
        detail = LocalizedStrings.PickleListScreen.Item.daysSealed(with: pickle.pickledOn)
    }
    
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
    var pickleListItems: BehaviorRelay<[PickleListItem]> { get }
    /// Fetches pickles, returns a pickle event stream
    var fetchPickles: Observable<PickleEvent> { get }
    /// The selected pickle index path
    var selectedPickle: BehaviorRelay<IndexPath?> { get }
    /// Composes a pickle, returns a pickle compose event stream
    var composePickle: Observable<PickleComposeEvent> { get }
    /// The initializer for PickleListModelable
    ///
    /// - Parameters:
    ///   - workspace: the current workspace for data
    ///   - coordinator: the coordinator for navigation
    ///   - service: a pickle providing service
    init(workspace: Workspace, coordinator: Coordinating, service: PickleProviding)
}

final class PickleListViewModel : PickleListModelable {

    private(set) var title = BehaviorRelay(value: LocalizedStrings.PickleListScreen.Title.default)
    private(set) var emptyListText = BehaviorRelay(value: LocalizedStrings.PickleListScreen.List.empty)
    private(set) var isRefreshing = BehaviorRelay(value: false)
    private(set) var pickleListItems = BehaviorRelay(value: [PickleListItem]())
    private(set) var selectedPickle:BehaviorRelay<IndexPath?> = BehaviorRelay(value: nil)
    fileprivate let workspace: Workspace
    fileprivate let coordinator: Coordinating
    fileprivate let service: PickleProviding
    fileprivate let disposeBag = DisposeBag()
    fileprivate var sortedPickles = BehaviorRelay(value: [Pickle]())
    
    var fetchPickles: Observable<PickleEvent> {
        return service
            .fetchPickes()
            .map { event -> PickleEvent in
                switch event {
                case .completed(let pickles):
                    self.isRefreshing.accept(false)
                    self.workspace.pickles.accept(pickles)
                    return .completed(pickles.count)
                case .error(let error):
                    self.isRefreshing.accept(false)
                    self.coordinator.display(error: .network)
                    return .error(error)
                case .waiting:
                    self.isRefreshing.accept(true)
                    return .fetching
                }
            }
            .asObservable()
    }
    
    var composePickle: Observable<PickleComposeEvent> {
        return coordinator.composePickle
    }
    
    init(workspace: Workspace, coordinator: Coordinating, service: PickleProviding) {
        
        self.workspace = workspace
        self.coordinator = coordinator
        self.service = service
        
        workspace.pickles.asObservable()
            .map({ $0.sorted(by: { (lhs, rhs) in
                return lhs.pickledOn > rhs.pickledOn
            })})
            .bind(to: self.sortedPickles)
            .disposed(by: disposeBag)

        sortedPickles
            .asObservable()
            .map({$0.map( {PickleListItem(pickle: $0)})})
            .bind(to: self.pickleListItems)
            .disposed(by: disposeBag)
        
        selectedPickle
            .asObservable()
            .subscribe(onNext: { selectedPickleIndex in
                guard let selectedPickleIndex = selectedPickleIndex else {
                    return
                }
                let pickle = self.sortedPickles.value[selectedPickleIndex.row]
                self.coordinator.display(pickle: pickle)
            })
            .disposed(by: disposeBag)
    }

}
