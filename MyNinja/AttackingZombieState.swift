//
//  AttackingZombieState.swift
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

class AttackingZombieState: GKState {
    let zombie:ZombieSprite
    
    init(zombie:ZombieSprite) {
        self.zombie = zombie
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print ("a zombie attack")
        playAttackAnimation()
        self.zombie.run(SKAction.playSoundFileNamed("NFF-dry-punch.wav", waitForCompletion: true))
    }
    
    func playAttackAnimation() {
        let postWait = SKAction.wait(forDuration: 0.8)
        self.zombie.size = self.zombie.zombie.Attack_1_().size()
        let anim = SKAction.animate(with: self.zombie.zombie.Attack__(), timePerFrame: 0.08)
        let attack = SKAction.sequence([anim, postWait])
        self.zombie.run(attack, completion: {
            print ("Going back to idle")
            self.zombie.stateMachine?.enter(IdleZombieState.self)
        })
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        /*
         This state can only transition to the partially full and empty
         states.
         */
        switch stateClass {
        case is DyingZombieState.Type, is IdleZombieState.Type:
            return true
            
        default:
            return false
        }
    }
    
    override func update(deltaTime: TimeInterval) {
    }
}
