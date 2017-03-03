//
//  MenuScene.swift
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

class GameOverScene: SKScene, SKPhysicsContactDelegate {
    var bg:SKSpriteNode?;
    var start:SKLabelNode?;
    override func didMove(to view: SKView) {
        self.bg = self.childNode(withName: "//bg") as? SKSpriteNode
        self.start = self.childNode(withName: "//start_btn") as? SKLabelNode
        
        let radians = M_PI/24.0
        let rotate = SKAction.rotate(byAngle: CGFloat(radians), duration: 10)
        let antiRotate = SKAction.rotate(byAngle: -CGFloat(radians), duration: 10)
        let rotateAnim = SKAction.sequence([rotate, antiRotate])
        self.bg?.run(SKAction.repeatForever(rotateAnim))
        
        let zoomDezoom = SKAction.sequence([SKAction.scale(to: CGFloat(1.05), duration: 2),
                                            SKAction.scale(to: CGFloat(0.95), duration: 0.9)])
        let animMenu = SKAction.repeatForever(zoomDezoom)
        self.start?.run(animMenu)
        
        // The Ninja
        let player = PlayerSprite()
        self.addChild(player)
        player.xScale = 0.75
        player.yScale = 0.75
        player.position.x = -100
        player.stateMachine.enter(DyingState.self)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 36:
            self.removeAllActions()
            let levelName = "Level_" + String(format: "%02d", GameScene.level)
            let scene = SKScene(fileNamed: levelName)
            let transition = SKTransition.fade(withDuration: 0.5)
            view?.presentScene(scene!, transition: transition)
            break
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
}
