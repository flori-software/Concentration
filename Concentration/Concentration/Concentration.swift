//
//  Concentration.swift
//  Concentration
//
//  Created by Arkadiusz Paluszek on 30.05.19.
//  Copyright © 2019 Arkadiusz Paluszek. All rights reserved.
//

import Foundation

struct Concentration {
    private(set) var cards =  [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                // Dieser Ausdruck sagt aus, dass cards[index] false sein soll, es sei denn, der index entspricht dem neuen Wert der in Set gesetzt wird
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of card")
        for _ in  1...numberOfPairsOfCards {
            let card = Card()
            // 2 x - weil wir jede Karte 2 x brauchen: 2 x cards.append(card) oder alternativ:
            cards += [card, card]
            
        }
        // TODO: Shuffle the cards
        var emojis = [Card]()
        var freie_positionen = [Int]()
        // Die zur Verfügung stehenden Positionen werden in ein Array geschrieben
        for index in cards.indices {
            freie_positionen.append(index)
        }
        var aktuelle_position = 0
        while freie_positionen.count > 0 {
            let zufallszahl = Int(arc4random_uniform(UInt32(freie_positionen.count - 1)))
            emojis.append(cards[freie_positionen[zufallszahl]])
            freie_positionen.remove(at: zufallszahl)
            aktuelle_position += 1
        }
        cards = emojis
    }
}
