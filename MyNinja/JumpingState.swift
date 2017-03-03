//
//  JumpingState.swift
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

class JumpingState: GKState {
    let player:PlayerSprite
    let jumpForce = CGFloat(1200)
    
    init(player:PlayerSprite) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        print("Go Jump")
        self.player.onGround = false
        self.player.physicsBody?.velocity.dy = jumpForce
        playJumpAnimation()
    }
    
    func playJumpAnimation() {
        self.player.size = self.player.ninja.Jump__000().size()
        let jumpAnim = SKAction.animate(with: self.player.ninja.Jump__(), timePerFrame: 0.1)
        self.player.run(jumpAnim)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        /*
         This state can only transition to the partially full and empty
         states.
         */
        switch stateClass {
        case is FallingState.Type:
            return true
            
        default:
            return false
        }
    }
    
    override func update(deltaTime: TimeInterval) {
        // Handle Go Falling
        if (self.player.physicsBody?.velocity.dy)! < CGFloat(0) {
            self.player.stateMachine?.enter(FallingState.self)
        }
    }
}
