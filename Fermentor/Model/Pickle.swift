//
//  Pickle.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Pickle {

    var name: String
    var pickledOn: Date
    var usesVinegar: Bool
    
    init?(json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let name = json["name"].string,
              let usesVinegar = json["usesVinegar"].bool,
              let pickedOn = json["pickedOn"].string,
              let pickedOnDate = dateFormatter.date(from: pickedOn) else {
                return nil
        }
        
        self.name = name
        self.pickledOn = pickedOnDate
        self.usesVinegar = usesVinegar
    }
    
}
