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

enum UpdatePickleEvent {
    case updating
    case error(Swift.Error)
    case completed
}

protocol PickleDetailModelable {
    
    var title: BehaviorRelay<String?> { get }
    var pickNameTitle: Observable<String?> { get }
    var usesVinegarTitle: Observable<String?> { get }
    var usesVinegar: BehaviorRelay<Bool> { get }
    var sealedOnTitle: Observable<String?> { get }
    var sealedOn: BehaviorRelay<Date> { get }
    var isEditing: BehaviorRelay<Bool> { get }
    
    init(workspace: Workspace, pickle: Pickle, coordinator: Coordinating, service: PickleProviding)
    
    func update() -> Observable<UpdatePickleEvent>?
}

final class PickleDetailViewModel : PickleDetailModelable {

    private(set) var title:BehaviorRelay<String?> = BehaviorRelay(value: "")
    private(set) var pickNameTitle:Observable<String?> = Observable.just("Name")
    private(set) var usesVinegarTitle:Observable<String?> = Observable.just("Uses Vinegar")
    private(set) var usesVinegar = BehaviorRelay(value: false)
    private(set) var sealedOnTitle:Observable<String?> = Observable.just("Seal date")
    private(set) var sealedOn = BehaviorRelay(value: Date())
    private(set) var isEditing = BehaviorRelay(value: false)

    fileprivate let workspace: Workspace
    fileprivate let pickle: Pickle
    fileprivate let coordinator: Coordinating
    fileprivate let service: PickleProviding
    
    fileprivate let disposeBag = DisposeBag()

    init(workspace: Workspace, pickle: Pickle, coordinator: Coordinating, service: PickleProviding) {
        
        self.workspace = workspace
        self.pickle = pickle
        self.service = service
        self.coordinator = coordinator
        
        sealedOn.accept(pickle.pickledOn)
        title.accept(pickle.name.capitalized)
        usesVinegar.accept(pickle.usesVinegar)

        sealedOnTitle = Observable.combineLatest(isEditing, sealedOn) { (isEditing, sealedOn) in
            if isEditing {
                return LocalizedStrings.PickleDetailScreen.Seal.editing
            } else {
                return LocalizedStrings.PickleDetailScreen.Seal.default(with: sealedOn)
            }
        }
        
        usesVinegarTitle = Observable.combineLatest(isEditing, usesVinegar) { (isEditing, usesVinegar) in
            if isEditing {
                return "Pickled with vinegar"
            } else {
                return usesVinegar ? "Pickled with vinegar" : "Fermented"
            }
        }
        
        pickNameTitle = Observable.combineLatest(isEditing, title) { (isEditing, title) in
            return isEditing ? "Name" : title
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
