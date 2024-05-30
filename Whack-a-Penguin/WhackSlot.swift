//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by Rodrigo Cavalcanti on 29/05/24.
//

import SpriteKit

class WhackSlot: SKNode {
    var isVisible = false
    var isHit = false
    
    var charNode: SKSpriteNode!
    
    func configure(at position: CGPoint) { // Creating a config func instead of init in order to avoid having multiple inits to satisfy required init.
        
        // Add a hole at its current position
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 16.5) // puts it slightly above the whackHole, just enough to line up the mask.
        cropNode.zPosition = 1 // put it to the front of other nodes
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        
        charNode = SKSpriteNode(imageNamed: "good1")
        charNode.position = CGPoint(x: 0, y: -120) // putting character node below the whack hole. Y is character's height + 10.
        charNode.name = "character"
        
        cropNode.addChild(charNode) // crop node only crops nodes that are inside it. So we need to have a clear hierarchy: the slot has the hole and crop node as children, and the crop node has the character node as a child.
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: 115, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "good\(Int.random(in: 1...5))")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "bad\(Int.random(in: 1...5))")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -115, duration: 0.05))
        isVisible = false
    }
}
