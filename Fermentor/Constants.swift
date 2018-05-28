//
//  Constants.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 25/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let secondsInADay = Double(86400)
}

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
        
        enum Item {
            static let pickled = NSLocalizedString("pickle.list.item.pickled")
            static let fermented = NSLocalizedString("pickle.list.item.fermented")
            
            static func daysSealed(with date: Date) -> String {
                let days = Int(floor(date.timeIntervalSince(Date()) / Constants.secondsInADay)) * -1
                let format = NSLocalizedString("pickle.list.item.days.sealed")
                return String(format: format, days)
            }
        }
    }

    enum PickleDetailScreen {
        
        enum Seal {
            
            static let update = NSLocalizedString("pickle.detail.seal.update")
            
            static func `default`(with date: Date) -> String {
                let formatter = DateFormatter()
                formatter.dateFormat =  NSLocalizedString("dateformats.long")
                let format = NSLocalizedString("pickle.detail.seal.default")
                return String(format: format, formatter.string(from: date))
            }
        }
        
        enum PickleName {
           static let title = NSLocalizedString("pickle.detail.pickle.name.title")
        }
        
        enum UsesVinegarTitle {
            static let fermented = NSLocalizedString("pickle.detail.uses.vinegar.title.fermented")
            static let pickled = NSLocalizedString("pickle.detail.uses.vinegar.title.pickled")
        }
    }

}


fileprivate func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
