//
//  Falling.swift
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

class FallingState: GKState {
    let player:PlayerSprite
    
    init(player:PlayerSprite) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print("Go Fall")
        playGlideAnimation()
    }
    
    func playGlideAnimation() {
        self.player.size = self.player.ninja.Glide_000().size()
        let glideAnim = SKAction.animate(with: self.player.ninja.Glide_(), timePerFrame: 0.05)
        let glide = SKAction.repeatForever(glideAnim)
        self.player.run(glide)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        /*
         This state can only transition to the partially full and empty
         states.
         */
        switch stateClass {
        case is IdleState.Type:
            return true
            
        default:
            return false
        }
    }
    
    override func update(deltaTime: TimeInterval) {
        // Handle Go Fall to Idle
        if (self.player.physicsBody?.velocity.dy)! >= CGFloat(0) && (self.player.physicsBody?.velocity.dy)! < CGFloat(20.0){
            self.player.stateMachine?.enter(IdleState.self)
        }
    }
}
