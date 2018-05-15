//
//  PickleDetailViewModel.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit

protocol PickleDetailModelable {
    
    init(context: Context, pickle: Pickle)
    
}

final class PickleDetailViewModel : PickleDetailModelable {

    fileprivate let context: Context
    fileprivate let pickle: Pickle
    
    init(context: Context, pickle: Pickle) {
        self.context = context
        self.pickle = pickle
    }
    
}
