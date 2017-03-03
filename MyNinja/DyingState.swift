//
//  DyingState.swift
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

class DyingState: GKState {
    let player:PlayerSprite
    
    init(player:PlayerSprite) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print("Go Die")
        playDieAnimation()
        redefinePhysicsBody()
    }
    
    func playDieAnimation() {
        self.player.size = self.player.ninja.Dead__000().size()
        let anim = SKAction.animate(with: self.player.ninja.Dead__(), timePerFrame: 0.07)
        self.player.removeAllActions()
        self.player.run(anim)
    }
    
    func redefinePhysicsBody() {
        let newWidth = self.player.size.width
        let newHeight = self.player.size.height * 0.4
        
        let rect = CGRect(origin:CGPoint(x: -100, y: -100), size:CGSize(width: newWidth, height: newHeight))
        self.player.physicsBody = SKPhysicsBody(edgeLoopFrom:rect)
        
        //self.player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: newWidth, height: newHeight))
        self.player.physicsBody?.isDynamic = true
        self.player.physicsBody?.allowsRotation = false
        self.player.physicsBody?.affectedByGravity = true
        self.player.physicsBody?.contactTestBitMask = 	0x00000001
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
    
    override func update(deltaTime: TimeInterval) {
    }
}
