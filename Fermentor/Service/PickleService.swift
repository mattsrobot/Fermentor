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
import Alamofire
import SwiftyJSON

protocol PickleProviding {
    
    @discardableResult func update(pickle: Pickle) -> Observable<ProviderEvent<Pickle>>
    @discardableResult func fetchPickes() -> Observable<ProviderEvent<[Pickle]>>
    
}

final class PickleService : PickleProviding {
    
    
    func update(pickle: Pickle) -> Observable<ProviderEvent<Pickle>> {
        return Observable.create({ observer -> Disposable in
            observer.on(.next(.waiting))
            Alamofire
                .request("\(ConfigurationStrings.host)/api/pickles",
                         method: .patch,
                         parameters: pickle.toJSON,
                         encoding: JSONEncoding.default)
                .responseJSON { response in
                    guard let result = response.result.value,
                          let updatedPickle = Pickle(json: JSON(result)) else {
                             observer.on(.next(.error(ProviderError.invalidJSON)))
                             return
                    }
                    observer.on(.next(ProviderEvent.completed(updatedPickle)))
            }
            return Disposables.create()
        })
    }
    
    func fetchPickes() -> Observable<ProviderEvent<[Pickle]>> {
        return Observable.create({ observer -> Disposable in
            observer.on(.next(.waiting))
            Alamofire
                .request("\(ConfigurationStrings.host)/api/pickles")
                .responseJSON { response in
                    guard let result = response.result.value as? [Any] else {
                        observer.on(.next(.error(ProviderError.invalidJSON)))
                        return
                    }
                    let pickles = result
                        .map({JSON($0)})
                        .flatMap({Pickle(json:$0)})
                    observer.on(.next(.completed(pickles)))
            }
            return Disposables.create()
        })
    }
}
