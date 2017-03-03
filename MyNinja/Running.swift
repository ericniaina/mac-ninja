//
//  Running.swift
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

class RunningState: GKState {
    let player:PlayerSprite
    let dampeningForce = CGFloat(0.93)
    let forwardMove: CGFloat = 2000.0
    
    let burstPath = Bundle.main.path(forResource: "RunningParticule",
                                     ofType: "sks")
    var burstNode:SKEmitterNode?
    
    init(player:PlayerSprite) {
        self.player = player
        self.burstNode = NSKeyedUnarchiver.unarchiveObject(withFile: burstPath!)
            as? SKEmitterNode
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print ("go run")
        playRunAnimation()
    }
    
    func playRunAnimation() {
        self.player.size = self.player.ninja.Run__000().size()
        let runAnim = SKAction.animate(with: self.player.ninja.Run__(), timePerFrame: 0.05)
        let run = SKAction.repeatForever(runAnim)
        self.player.run(run)
        
        self.player.parent?.addChild(self.burstNode!)
        self.burstNode?.zPosition = 3
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        /*
         This state can only transition to the partially full and empty
         states.
         */
        switch stateClass {
        case is IdleState.Type, is DyingState.Type:
            return true
            
        case is JumpingState.Type:
            return self.player.onGround
        default:
            return false
        }
    }
    
    override func willExit(to nextState: GKState) {
        burstNode?.removeFromParent()
    }
    
    override func update(deltaTime: TimeInterval) {
        self.player.physicsBody?.velocity.dx = (self.player.physicsBody?.velocity.dx)! * dampeningForce;
        
        let forwardStep: CGFloat = forwardMove * CGFloat(deltaTime)
        
        if self.player.forward {
            self.player.physicsBody?.velocity.dx  = (self.player.physicsBody?.velocity.dx)! + forwardStep
        }
        
        if self.player.backward {
            self.player.physicsBody?.velocity.dx  = (self.player.physicsBody?.velocity.dx)! - forwardStep
        }
        
        
        // Facing
        if self.player.forward {
            self.player.xScale = abs(self.player.xScale)
        }
        else if self.player.backward {
            self.player.xScale = -1.0 * abs(self.player.xScale)
        }
        
        if (!self.player.forward && !self.player.backward){
            self.player.stateMachine?.enter(IdleState.self)
        }
        
        // particule position
        self.burstNode?.position = self.player.position
        self.burstNode?.position.y -= self.player.size.height/2
        if self.player.forward {
            self.burstNode?.emissionAngle = CGFloat(M_PI * 3/4)
        }
        else if self.player.backward {
            self.burstNode?.emissionAngle = CGFloat(M_PI / 4)
        }
        
    }
}
