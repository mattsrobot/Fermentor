//
//  PrettyLogger.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 25/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit


enum Log {
    
    static func debug(_ statement: String) {
        print("🐜 \(statement)")
    }
    
    static func verbose(_ statement: String) {
        print("🔦 \(statement)")
    }
    
    static func failure(_ statement: String) {
        print("🔥 \(statement)")
    }
    
}


