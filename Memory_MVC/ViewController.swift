//
//  ViewController.swift
//  Memory_MVC
//
//  Created by Stephan Kurpjuweit on 17.10.19.
//  Copyright © 2019 Stephan Kurpjuweit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Model
    
    private lazy var game = gameInit()
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count+1) / 2
    }
    
    // MARK: View Outlets
    
    @IBOutlet private var cardButtons: [UIButton]!
        
    @IBOutlet private weak var flipsLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private weak var gameScoreLabel: UILabel! {
        didSet {
            updateGameScoreLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributesFlipsCount: [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        ]
        
        let flipsLabelStr = NSAttributedString(string:"Flips: \(game.flipCount)", attributes: attributesFlipsCount)
        flipsLabel.attributedText = flipsLabelStr
    }
    
    private func updateGameScoreLabel() {
        let attributesGameScore: [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        ]
        let gameScoreStr = NSAttributedString(string:"Game Score: \(game.gameScore)", attributes: attributesGameScore)
        gameScoreLabel.attributedText = gameScoreStr
    }
    
    // MARK: Actions
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }

    @IBAction private func newGameButtonPressed(_ sender: UIButton) {
        newGame()
    }
    
    // MARK: Initialization
    
    // called during initailization and for new game
    private func gameInit() -> MemoryGame {
        emojiChoicesLeft = emojiChoicesAll.randomElement()?.value ?? ""
        return MemoryGame(numberOfPairsOfCards: numberOfPairsOfCards)
    }
    
    func newGame() {
        game = gameInit()
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        for button in cardButtons {
            button.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
            button.setTitle("", for: UIControl.State.normal)
            button.titleLabel?.font =  UIFont.systemFont(ofSize: 50)
        }
    }
    
    // MARK: Update View
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 0) : #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
            }
        }
        updateFlipCountLabel()
        updateGameScoreLabel()
    }
    
    // MARK: EMojis
    
    private let emojiChoicesAll = [
        "sport": "🚴🏻‍♀️🏉🏂⛳️🏁⛸⛷👟⚽️🏀",
        "animals": "🦞🦜🐘🦢🦡😾🐰🐝🐌🦀🐳",
        "smileys": "😀😇😍🤯☹️🤓🤩😖😤",
        "helloween": "🎃👻👽👾💀☠️🤖",
    ]
    
    private var emojiChoicesLeft = ""
    
    private var emoji = [Card:String]()
    
    private func emoji (for card: Card) -> String {
        if emoji[card] == nil , !emojiChoicesLeft.isEmpty {
            let randomStringIndex = emojiChoicesLeft.index(emojiChoicesLeft.startIndex, offsetBy: Int.random(in: 0..<emojiChoicesLeft.count))
            emoji[card] = String(emojiChoicesLeft.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}
