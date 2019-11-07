//
//  Card.swift
//  Memory_MVC
//
//  Created by Stephan Kurpjuweit on 17.10.19.
//  Copyright © 2019 Stephan Kurpjuweit. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var isFaceUp = false {
        willSet(newStatus) {
            if isFaceUp == true && newStatus == false { isKnown = true }
        }
    }
    var isMatched = false
    var isKnown = false
    
    // unique ID, set in constructor
    private var identifier: Int
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    // Emoji? No! Model is UI independent
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}


