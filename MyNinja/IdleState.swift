//
//  IdleState.swift
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

class IdleState: GKState {
    let player:PlayerSprite
    
    init(player:PlayerSprite) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print ("go idle")
        self.player.onGround = true
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        self.player.size = self.player.ninja.Idle__000().size()
        let idleAnim = SKAction.animate(with: self.player.ninja.Idle__(), timePerFrame: 0.08)
        let idle = SKAction.repeatForever(idleAnim)
        self.player.run(idle)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        /*
         This state can only transition to the partially full and empty
         states.
         */
        switch stateClass {
        case is AttackingState.Type, is RunningState.Type, is JumpingState.Type, is DyingState.Type:
            return true
            
        case is ThrowingState.Type:
            return self.player.canThrow()
            
        default:
            return false
        }
    }
    
    override func update(deltaTime: TimeInterval) {
    }
}
