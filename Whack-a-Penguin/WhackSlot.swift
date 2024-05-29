//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by Rodrigo Cavalcanti on 29/05/24.
//

import SpriteKit

class WhackSlot: SKNode {
    func configure(at position: CGPoint) { // Creating a config func instead of init in order to avoid having multiple inits to satisfy required init.
        
        // Add a hole at its current position
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
    }
}
