//
//  Kunai.swift
//  MyNinja
//
//  TP 1 MacOSX
//  Paris Diderot
//  Binonme
//  Rakotonirina Eric Niaina
//  Rahajarivelo Manambintsoa Miora Tahina
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation
import SpriteKit
class KunaiSprite:SKSpriteNode {
    let ninja = Ninja()
    
    init() {
        super.init(texture: ninja.Kunai(), color: SKColor.clear, size: ninja.Kunai().size())
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.contactTestBitMask = 	0x00000001
        self.name = "kunai"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func removeKunai() {
        self.run(SKAction.sequence([SKAction.wait(forDuration: 1),
                                          SKAction.fadeOut(withDuration: 0.1),
                                          SKAction.fadeIn(withDuration: 0.1),
                                          SKAction.fadeOut(withDuration: 0.1),
                                          SKAction.fadeIn(withDuration: 0.1),
                                          SKAction.fadeOut(withDuration: 0.3),
                                          SKAction.removeFromParent()]))
    }
}
