//
//  Memory_Model.swift
//  Memory_MVC
//
//  Created by Stephan Kurpjuweit on 17.10.19.
//  Copyright © 2019 Stephan Kurpjuweit. All rights reserved.
//

import Foundation

struct MemoryGame {
    
    private(set) var cards = [Card]()
    
    private(set) var flipCount = 0
    private(set) var gameScore = 0
    
    // contains index if only one card is face up, nil otherwise
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set(newValue) {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        // only for debuggng
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): index not in the cards")
        // only if chosen card has not been matched before
        if !cards[index].isMatched {
            // case 1: now two cards are face up
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // case 1.1: the two cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    cards[index].isFaceUp = true
                    gameScore += 2
                }
                // case 1.2: the two cards do not match
                else {
                    if cards[index].isKnown { gameScore -= 1 }
                    if cards[matchIndex].isKnown { gameScore -= 1 }
                    cards[index].isFaceUp = true
                }
            }
            // case 2: no card or two cards were face up ==> now only one card should be face up
            else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        flipCount += 1
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            
            // add card and matching card
            cards += [card, card]
        }
        cards.shuffle()
    }
    
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
