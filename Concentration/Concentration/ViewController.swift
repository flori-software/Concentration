//
//  ViewController.swift
//  Concentration
//
//  Created by Arkadiusz Paluszek on 30.05.19.
//  Copyright © 2019 Arkadiusz Paluszek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // "lazy" bedeutet, dass es erst initialisiert wird, wenn es tatsächlich zur Benutzung kommt
    // An dieser Stelle steht nämlich cardButtons noch nicht zur Verfügung
    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
            return (cardButtons.count + 2) / 2
    }
    private(set) var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            flipCount += 1
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card wasn't in card buttons")
        }
        
        
    }

    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            }
        }
    }
    
    private var emojiChoices = ["😻", "😎", "😇", "😝", "🤪", "🕵🏽‍♀️", "👨🏼‍🌾", "👻", "👅", "👀"]
    
    // Die Emojis werden in ein Dictionary gepackt
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
