//
//  ThrowingState.swift
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

class ThrowingState: GKState {
    let player:PlayerSprite
    
    var startTime:DispatchTime?
    var endTime:DispatchTime?
    
    let MAX_POWER = 3.0
    let MIN_POWER = 1.0
    let THROW_DY_RATIO = CGFloat(0.4)
    let BASE_POWER = CGFloat(750)
    
    let burstPath = Bundle.main.path(forResource: "ConcentrationParticule",
                                     ofType: "sks")
    var burstNode:SKEmitterNode?
    
    init(player:PlayerSprite) {
        self.player = player
        self.burstNode = NSKeyedUnarchiver.unarchiveObject(withFile: burstPath!)
            as? SKEmitterNode
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        startTime = DispatchTime.now()
        
        print("Go Throw")
        startThrowAnimation()
    }
    
    func startThrowAnimation() {
        self.player.run(SKAction.playSoundFileNamed("NFF-heart-beat.wav", waitForCompletion: true))
        self.player.removeAllActions()
        self.player.size = self.player.ninja.Throw__000().size()
        let throwAnim = SKAction.animate(with: self.player.ninja.Throw1__(), timePerFrame: 0.06)
        self.player.run(throwAnim)
        
        self.player.parent?.addChild(self.burstNode!)
    }
    
    func finishThrowAnimation() {
        let throwAnim = SKAction.animate(with: self.player.ninja.Throw2__(), timePerFrame: 0.07)
        self.player.run(throwAnim)
        
        burstNode?.removeFromParent()
    }
    
    
    func throwKunai() {
        self.player.run(SKAction.playSoundFileNamed("NFF-throw-05.wav", waitForCompletion: true))
        self.endTime = DispatchTime.now()
        let nanoTime = (self.endTime?.uptimeNanoseconds)! - (self.startTime?.uptimeNanoseconds)!
        var timeInterval = Double(nanoTime) / 1_000_000_000
        if(timeInterval < MIN_POWER) {
            timeInterval = MIN_POWER
        }
        if(timeInterval > MAX_POWER) {
            timeInterval = MAX_POWER
        }
        
        finishThrowAnimation()
        let kunai = KunaiSprite()
        kunai.position = self.player.position
        kunai.position.x += CGFloat(100 * self.player.xScale)
        self.player.scene?.addChild(kunai)
        kunai.xScale = self.player.xScale
        kunai.physicsBody?.velocity.dx = BASE_POWER * self.player.xScale * CGFloat(timeInterval)
        kunai.physicsBody?.velocity.dy = BASE_POWER * THROW_DY_RATIO * CGFloat(timeInterval)
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
    
    override func willExit(to nextState: GKState) {
        print ("Throwing now")
        self.throwKunai()
        self.player.throwKunai()
    }
    
    override func update(deltaTime: TimeInterval) {
        self.burstNode?.position = self.player.position
    }
}
