//
//  ZombieSprite.swift
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
import GameKit

class ZombieSprite:SKSpriteNode {
    let zombie = Zombie()
    var stateMachine:GKStateMachine?
    
    var player:PlayerSprite?
    
    var receivedAttack = 0;
    
    init(player:PlayerSprite) {
        super.init(texture: zombie.Idle_1_(), color: SKColor.clear, size: zombie.Idle_1_().size())
        initData()
        self.player = player
    }
    
    func initData() {
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.5, height: self.size.height * 0.95))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.contactTestBitMask = 	0x00000001
        self.name = "zombie"
        
        // Creates and adds states to the dispenser's state machine.
        stateMachine = GKStateMachine(states: [
            IdleZombieState(zombie: self),
            DyingZombieState(zombie: self),
            WalkingZombieState(zombie: self),
            AttackingZombieState(zombie: self),
            ])
        
        stateMachine?.enter(IdleZombieState.self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initData()
    }
    
    func attackedBy(node: SKNode) {
        if(self.receivedAttack > 2) {
            self.stateMachine?.enter(DyingZombieState.self)
        }
        else {
            self.receivedAttack = self.receivedAttack + 1
        }
        
        self.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1),
                                    SKAction.fadeIn(withDuration: 0.1),
                                    SKAction.fadeOut(withDuration: 0.1),
                                    SKAction.fadeIn(withDuration: 0.1)]))
        
        let sign = (self.position.x - node.position.x) / abs(self.position.x - node.position.x)
        self.physicsBody?.velocity.dx = 400 * sign;
        
        let score = SKLabelNode(fontNamed: "Chalkduster")
        score.text = "-1"
        score.horizontalAlignmentMode = .right
        score.position = CGPoint(x: 0, y: 0)
        score.zPosition = 10
        score.xScale = self.xScale
        self.addChild(score)
        let moveto = SKAction.move(to: CGPoint(x:0, y: 150), duration: 0.5)
        score.run(SKAction.sequence([moveto, SKAction.removeFromParent()]))
    }
    
    func update(currentTime : TimeInterval) {
        stateMachine?.update(deltaTime: currentTime)
        if abs((self.player?.position.y)! - self.position.y) < self.size.height {
            //print ("Go CHAAAASSSSE!")
            if((self.player?.position.x)! != self.position.x) {
                self.stateMachine?.enter(WalkingZombieState.self)
            }
        }
        else {
            self.stateMachine?.enter(IdleZombieState.self)
        }
    }
}
