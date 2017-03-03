//
//  AttackingState.swift
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

class AttackingState: GKState {
    let player:PlayerSprite
    
    init(player:PlayerSprite) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print ("a player attack")
        playAttackAnimation()
        attack()
        self.player.run(SKAction.playSoundFileNamed("steelsword.mp3", waitForCompletion: false))
        print ("Playing sound attack")
    }
    
    func playAttackAnimation() {
        //let postWait = SKAction.wait(forDuration: 0.8)
        self.player.size = self.player.ninja.Attack__000().size()
        let anim = SKAction.animate(with: self.player.ninja.Attack__(), timePerFrame: 0.08)
        //let attack = SKAction.sequence([anim, postWait])
        self.player.run(anim, completion: {
            print ("Going back to idle")
            self.player.stateMachine?.enter(IdleState.self)
        })
    }
    
    func attack() {
        let preWait = SKAction.wait(forDuration: 0.3)
        let postWait = SKAction.wait(forDuration: 0.5)
        let sword = SwordSprite()
        let runAttack = SKAction.run({
            sword.position = self.player.position
            sword.position.x += CGFloat(100 * self.player.xScale)
            self.player.scene?.addChild(sword)
        })
        self.player.run(SKAction.sequence([preWait, runAttack, postWait]), completion: {
            print ("End of Attacking")
            sword.removeFromParent()
        })
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
    }
}
