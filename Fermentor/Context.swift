//
//  Context.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol Context {
    
    var pickles: BehaviorRelay<[Pickle]> { get }
    
}

final class PickleJar : Context {

    var pickles = BehaviorRelay(value: [Pickle]())
    
}
