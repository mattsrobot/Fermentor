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

    var id: Int
    var name: String
    var pickledOn: Date
    var usesVinegar: Bool
    
    fileprivate static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }
    
    init(id: Int, name: String, pickledOn: Date, usesVinegar: Bool) {
        self.id = id
        self.name = name
        self.pickledOn = pickledOn
        self.usesVinegar = usesVinegar
    }
    
    init?(json: JSON) {
        
        guard let id = json["id"].int,
              let name = json["name"].string,
              let usesVinegar = json["usesVinegar"].bool,
              let pickedOn = json["pickedOn"].string,
              let pickedOnDate = Pickle.dateFormatter.date(from: pickedOn) else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.pickledOn = pickedOnDate
        self.usesVinegar = usesVinegar
    }
    
    var toJSON: [String : Any] {
        return ["id" : id,
                "name" : name,
                "usesVinegar" : usesVinegar,
                "pickledOn" : Pickle.dateFormatter.string(from: pickledOn)]
    }
    
}
