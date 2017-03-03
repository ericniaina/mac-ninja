//
//  SwordSprite.swift
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
class SwordSprite:SKSpriteNode {
    let WIDTH_RANGE = 75.0
    let HEIGHT_RANGE = 200.0
    init() {
        super.init(texture: nil, color: SKColor.clear, size: CGSize(width: WIDTH_RANGE, height: HEIGHT_RANGE))
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: WIDTH_RANGE, height: HEIGHT_RANGE))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.contactTestBitMask = 	0x00000001
        self.name = "sword"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
