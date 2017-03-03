//
//  IdleZombieState.swift
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

class IdleZombieState: GKState {
    let zombie:ZombieSprite
    
    init(zombie:ZombieSprite) {
        self.zombie = zombie
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print ("a zombie go idle")
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        self.zombie.removeAllActions()
        self.zombie.size = self.zombie.zombie.Idle_1_().size()
        let idleAnim = SKAction.animate(with: self.zombie.zombie.Idle__(), timePerFrame: 0.08)
        let idle = SKAction.repeatForever(idleAnim)
        self.zombie.run(idle)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        /*
         This state can only transition to the partially full and empty
         states.
         */
        switch stateClass {
        case is DyingZombieState.Type, is WalkingZombieState.Type, is AttackingZombieState.Type:
            return true
            
        default:
            return false
        }
    }
    
    override func update(deltaTime: TimeInterval) {
    }
}
