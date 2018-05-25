//
//  DisplayableError.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 25/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit

enum DisplayableErrorType {
    case alert
    case banner
}

struct DisplayableError : Swift.Error {
    
    let title: String
    let subtitle: String
    let image: UIImage?
    let type: DisplayableErrorType

    static let network = DisplayableError(title: LocalizedStrings.Error.Network.title,
                                          subtitle: LocalizedStrings.Error.Network.subtitle,
                                          image: nil,
                                          type: .alert)
}

