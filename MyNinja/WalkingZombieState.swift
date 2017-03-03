//
//  File.swift
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

class WalkingZombieState: GKState {
    let zombie:ZombieSprite
    
    init(zombie:ZombieSprite) {
        self.zombie = zombie
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print ("a zombie go walk")
        playWalkAnimation()
    }
    
    func playWalkAnimation() {
        self.zombie.size = self.zombie.zombie.Walk_1_().size()
        let walkAnim = SKAction.animate(with: self.zombie.zombie.Walk__(), timePerFrame: 0.08)
        let walk = SKAction.repeatForever(walkAnim)
        self.zombie.run(walk)
        self.zombie.run(SKAction.playSoundFileNamed("Zombie_Attack_Walk.mp3", waitForCompletion: true))
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        /*
         This state can only transition to the partially full and empty
         states.
         */
        switch stateClass {
        case is DyingZombieState.Type, is AttackingZombieState.Type, is IdleZombieState.Type:
            return true
            
        default:
            return false
        }
    }
    
    override func update(deltaTime: TimeInterval) {
        print ("Playing zombie walk")
        if((self.zombie.player?.position.x)! > self.zombie.position.x) {
            goRight()
        }
        else if((self.zombie.player?.position.x)! < self.zombie.position.x) {
            goLeft()
        }
    }
    
    func goRight() {
        self.zombie.physicsBody?.velocity.dx = 150
        self.zombie.xScale = 1.0
    }
    
    func goLeft() {
        self.zombie.physicsBody?.velocity.dx = -150
        self.zombie.xScale = -1.0
    }
}
