//
//  PlayerSprite.swift
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

class PlayerSprite : SKSpriteNode {
    let ninja = Ninja()
    var oldTime:TimeInterval = 0
    var kunais = 5
    
    var stateMachine: GKStateMachine!
    
    var onGround : Bool = false
    var forward : Bool = false
    var backward : Bool = false
    
    init() {
        super.init(texture: ninja.Idle__000(), color: SKColor.clear, size: ninja.Idle__000().size())
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.contactTestBitMask = 	0x00000001        
        // Creates and adds states to the dispenser's state machine.
        stateMachine = GKStateMachine(states: [
            RunningState(player: self),
            IdleState(player: self),
            JumpingState(player: self),
            FallingState(player: self),
            ThrowingState(player: self),
            DyingState(player: self),
            AttackingState(player: self)
            ])
        
        stateMachine.enter(IdleState.self)
        self.name = "ninja"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func canThrow()->Bool {
        return kunais > 0
    }
    
    func throwKunai() {
        kunais -= 1
    }
    
    func addPowerUp() {
        kunais += 10
        self.run(SKAction.playSoundFileNamed("NFF-confirmation.wav", waitForCompletion: true))
    }
    
    func update(currentTime : TimeInterval) {
        if self.forward || self.backward {
            stateMachine.enter(RunningState.self)
        } 
        
        //FSM Update
        let delta = currentTime - oldTime
        self.stateMachine.update(deltaTime: delta)
        oldTime = currentTime
    }
}
