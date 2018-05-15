//
//  PickleService.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PickleProviding {
    
    @discardableResult func fetchPickes() -> Observable<ProviderEvent<[Pickle]>>
    
}

final class PickleService : PickleProviding {

    func fetchPickes() -> Observable<ProviderEvent<[Pickle]>> {
        return Observable.create({ observer -> Disposable in
            observer.on(.next(.fetching))
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    
                let mockPickle = Pickle(name: "A Mocked Pickle", pickledOn: Date(), usesVinegar: true)
    
                observer.on(.next(.completed([mockPickle])))
            }
            return Disposables.create()
        })
    }
}
