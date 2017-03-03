//
//  DyingZombieState.swift
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
import GameplayKit

class DyingZombieState: GKState {
    let zombie:ZombieSprite
    
    init(zombie:ZombieSprite) {
        self.zombie = zombie
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print("Zombie Go Die")
        playDieAnimation()
        redefinePhysicsBody()
    }
    
    func playDieAnimation() {
        self.zombie.removeAllActions()
        self.zombie.physicsBody?.velocity.dx = 0
        self.zombie.physicsBody?.velocity.dy = 0
        self.zombie.size = self.zombie.zombie.Dead_1_().size()
        let dieAnim = SKAction.animate(with: self.zombie.zombie.Dead__(), timePerFrame: 0.07)
        self.zombie.run(SKAction.sequence([dieAnim,
                                    SKAction.wait(forDuration: 0.5),
                                    SKAction.fadeOut(withDuration: 0.1),
                                    SKAction.fadeIn(withDuration: 0.1),
                                    SKAction.fadeOut(withDuration: 0.1),
                                    SKAction.fadeIn(withDuration: 0.1),
                                    SKAction.fadeOut(withDuration: 0.3),
                                    SKAction.removeFromParent()]))
    }
    
    func redefinePhysicsBody() {
        let newWidth = self.zombie.size.height * 0.95
        let newHeight = self.zombie.size.width * 0.6
        self.zombie.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: newWidth, height: newHeight))
        self.zombie.physicsBody?.isDynamic = true
        self.zombie.physicsBody?.allowsRotation = false
        self.zombie.physicsBody?.affectedByGravity = true
        self.zombie.physicsBody?.contactTestBitMask = 	0x00000001
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
    override func update(deltaTime: TimeInterval) {
    }
}
