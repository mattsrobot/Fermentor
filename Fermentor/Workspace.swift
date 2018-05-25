//
//  Workspace.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa 

/// The workspace is an area where app wide state is held
protocol Workspace {
    
    /// The current list of pickles
    var pickles: BehaviorRelay<[Pickle]> { get }
    
    /// The current style to use for colors
    var style: Stylable { get }
}

/// The Kitchen is a concreate class implementing Workspace
struct Kitchen : Workspace {
    
    var pickles = BehaviorRelay(value: [Pickle]())
    var style: Stylable = PickleTheme()
    
}
