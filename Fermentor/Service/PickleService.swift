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
    
    @discardableResult func fetchPickes() -> Observable<ProviderEvent<[Pickle]>>
    
}

final class PickleService : PickleProviding {
    func fetchPickes() -> Observable<ProviderEvent<[Pickle]>> {
        return Observable.create({ observer -> Disposable in
            observer.on(.next(.fetching))
            Alamofire.request("http://localhost:3000/api/pickles").responseJSON { response in
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
