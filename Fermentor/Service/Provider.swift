//
//  Provider.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit

enum ProviderEvent<Item> {
    case fetching
    case error(Swift.Error)
    case completed(Item)
}
