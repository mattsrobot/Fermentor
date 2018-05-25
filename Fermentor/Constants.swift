//
//  Constants.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 25/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit

enum ConfigurationStrings {
    static let host = "http://localhost:3000"
}

enum ParsingStrings {
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}

enum LocalizedStrings {
    
    enum Error {
        
        enum Network {
            static let title = NSLocalizedString("unknown.error.network.connection.title")
            static let subtitle = NSLocalizedString("unknown.error.network.connection.description")
        }
        
    }
    
    enum PickleListScreen {
        
        enum Title {
            static let `default` = NSLocalizedString("pickle.list.title.default")
        }
        
        enum List {
            static let empty = NSLocalizedString("pickle.list.empty")
        }
    }

    enum PickleDetailScreen {
        
        enum Seal {
            
            static let editing = NSLocalizedString("pickle.detail.seal.editing")
            
            static func `default`(with date: Date) -> String {
                let formatter = DateFormatter()
                formatter.dateFormat =  NSLocalizedString("dateformats.long")
                let format = NSLocalizedString("pickle.detail.seal.editing")
                return String(format: format, formatter.string(from: date))
            }
            
        }
    }

}


fileprivate func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
