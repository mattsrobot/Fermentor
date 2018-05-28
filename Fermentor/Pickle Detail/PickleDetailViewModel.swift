//
//  PickleDetailViewModel.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum PickleDetailMode {
    
    case compose
    case read
    case update
    
    var isEditing : Bool {
        switch self {
        case .compose, .update:
            return true
        case .read:
            return false
        }
    }
}

enum UpdatePickleEvent {
    case updating
    case error(Swift.Error)
    case completed
}

protocol PickleDetailModelable {
    
    var mode: BehaviorRelay<PickleDetailMode> { get }
    var title: BehaviorRelay<String?> { get }
    var pickNameTitle: Observable<String?> { get }
    var usesVinegarTitle: Observable<String?> { get }
    var usesVinegar: BehaviorRelay<Bool> { get }
    var sealedOnTitle: Observable<String?> { get }
    var sealedOn: BehaviorRelay<Date> { get }
    
    init(workspace: Workspace, pickle: Pickle, coordinator: Coordinating, service: PickleProviding, mode: PickleDetailMode)
    
    func update() -> Observable<UpdatePickleEvent>?
}

final class PickleDetailViewModel : PickleDetailModelable {

    private(set) var mode = BehaviorRelay(value: PickleDetailMode.read)
    private(set) var title:BehaviorRelay<String?> = BehaviorRelay(value: "")
    private(set) var pickNameTitle:Observable<String?> = Observable.just("")
    private(set) var usesVinegarTitle:Observable<String?> = Observable.just("")
    private(set) var usesVinegar = BehaviorRelay(value: false)
    private(set) var sealedOnTitle:Observable<String?> = Observable.just("")
    private(set) var sealedOn = BehaviorRelay(value: Date())

    fileprivate let workspace: Workspace
    fileprivate let pickle: Pickle
    fileprivate let coordinator: Coordinating
    fileprivate let service: PickleProviding
    
    fileprivate let disposeBag = DisposeBag()

    init(workspace: Workspace, pickle: Pickle, coordinator: Coordinating, service: PickleProviding, mode: PickleDetailMode) {
        
        self.workspace = workspace
        self.pickle = pickle
        self.service = service
        self.coordinator = coordinator
        
        self.mode.accept(mode)
        sealedOn.accept(pickle.pickledOn)
        title.accept(pickle.name.capitalized)
        usesVinegar.accept(pickle.usesVinegar)

        sealedOnTitle = Observable.combineLatest(self.mode, sealedOn) { (mode, sealedOn) in
            switch mode {
            case .update, .compose:
                return LocalizedStrings.PickleDetailScreen.Seal.update
            case .read:
                return LocalizedStrings.PickleDetailScreen.Seal.default(with: sealedOn)
            }
        }
        
        usesVinegarTitle = Observable.combineLatest(self.mode, usesVinegar) { (isEditing, usesVinegar) in
            switch mode {
            case .update, .compose:
                return LocalizedStrings.PickleDetailScreen.UsesVinegarTitle.pickled
            case .read:
                return usesVinegar ?
                    LocalizedStrings.PickleDetailScreen.UsesVinegarTitle.pickled :
                    LocalizedStrings.PickleDetailScreen.UsesVinegarTitle.fermented
            }
        }
        
        pickNameTitle = Observable.combineLatest(self.mode, title) { (mode, title) in
            switch mode {
            case .update, .compose:
                return LocalizedStrings.PickleDetailScreen.PickleName.title
            case .read:
                return title
            }
        }
    
    }
    
    func update() -> Observable<UpdatePickleEvent>? {
        
        guard let name = title.value else {
            return nil
        }
        
        let usesVinegar = self.usesVinegar.value
        let sealedOn = self.sealedOn.value
        
        let updatePickle = Pickle(id: pickle.id,
                                  name: name,
                                  pickledOn: sealedOn,
                                  usesVinegar: usesVinegar)
        
        return service
            .update(pickle: updatePickle)
            .map { event -> UpdatePickleEvent in
                switch event {
                case .completed(_):
                    return .completed
                case .error(let error):
                    self.coordinator.display(error: .network)
                    return .error(error)
                case .waiting:
                    return .updating
                }
            }
            .asObservable()
    }
    
}
