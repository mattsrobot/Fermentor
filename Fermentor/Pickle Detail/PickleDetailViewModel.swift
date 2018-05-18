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

protocol PickleDetailModelable {
    
    var title: BehaviorRelay<String?> { get }
    var pickNameTitle: BehaviorRelay<String?> { get }
    var usesVinegarTitle: BehaviorRelay<String?> { get }
    var usesVinegar: BehaviorRelay<Bool> { get }
    
    init(workspace: Workspace, pickle: Pickle)
}

final class PickleDetailViewModel : PickleDetailModelable {

    private(set) var title:BehaviorRelay<String?> = BehaviorRelay(value: "")
    private(set) var pickNameTitle:BehaviorRelay<String?> = BehaviorRelay(value: "Pickle Name")
    private(set) var usesVinegarTitle:BehaviorRelay<String?> = BehaviorRelay(value: "Uses Vinegar (Yes)")
    private(set) var usesVinegar = BehaviorRelay(value: false)

    
    fileprivate let workspace: Workspace
    fileprivate let pickle: Pickle
    
    fileprivate let disposeBag = DisposeBag()

    init(workspace: Workspace, pickle: Pickle) {
        
        self.workspace = workspace
        self.pickle = pickle
        
        title.accept(pickle.name.capitalized)
        usesVinegar.accept(pickle.usesVinegar)
        
        usesVinegar
            .asObservable()
            .map({ "Uses Vinegar \($0 ? "(Yes)" : "(No)")"})
            .bind(to: self.usesVinegarTitle)
            .disposed(by: disposeBag)
        
        usesVinegar
            .asObservable()
            .map({ vinegar in
                let replacing = vinegar ? ("ferment", "pickle") : ("pickle", "ferment")
                return self.title.value?.lowercased().replacingOccurrences(of: replacing.0, with: replacing.1).capitalized ?? "" })
            .bind(to: self.title)
            .disposed(by: disposeBag)
    }
    
}
