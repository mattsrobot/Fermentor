//
//  Styles.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 19/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol Stylable {
    
    var primiaryColor: BehaviorRelay<UIColor> { get }
    
}

final class GreenPickleTheme : Stylable {

    private(set) var primiaryColor = BehaviorRelay(value: UIColor.red)
    
}
