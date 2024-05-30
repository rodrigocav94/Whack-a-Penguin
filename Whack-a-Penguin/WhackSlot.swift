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
    let characterSize: CGFloat = 130
    
    var charNode: SKSpriteNode!
    
    func configure(at position: CGPoint) { // Creating a config func instead of init in order to avoid having multiple inits to satisfy required init.
        
        // Add a hole at its current position
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 39) // puts it slightly above the whackHole, just enough to line up the mask.
        cropNode.zPosition = 1 // put it to the front of other nodes
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        
        charNode = SKSpriteNode(imageNamed: "good")
        charNode.position = CGPoint(x: 0, y: -characterSize - 15) // putting character node below the whack hole. Y is character's height - 10.
        charNode.size = CGSize(width: characterSize, height: characterSize)
        charNode.name = "character"
        
        cropNode.addChild(charNode) // crop node only crops nodes that are inside it. So we need to have a clear hierarchy: the slot has the hole and crop node as children, and the crop node has the character node as a child.
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        if let mudParticles = SKEmitterNode(fileNamed: "MudParticles") {
            mudParticles.position = CGPoint(x: 0, y: 0)
            addChild(mudParticles)
            
            let delay = SKAction.wait(forDuration: 0.25)
            let removeParticle = SKAction.run { [weak mudParticles] in
                mudParticles?.removeFromParent()
            }
            mudParticles.run(SKAction.sequence([delay, removeParticle]))
        }
        
        charNode.xScale = 1
        charNode.yScale = 1
        charNode.run(SKAction.moveBy(x: 0, y: characterSize, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "good\(Int.random(in: 1...11))")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "bad")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -characterSize, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25) // creates an action that waits for a period of time, measured in seconds.
        let hide = SKAction.moveBy(x: 0, y: -characterSize, duration: 0.05)
        let notVisible = SKAction.run { [unowned self] in
            self.isVisible = false
        } //  will run any code we want, provided as a closure. "Block" is Objective-C's name for a Swift closure.
        charNode.run(SKAction.sequence([delay, hide, notVisible])) // Takes an array of actions, and executes them in order. Each action won't start executing until the previous one finished.
    }
}
