//
//  GameScene.swift
//  MyNinja
//
//  TP 1 MacOSX
//  Paris Diderot
//  Binonme
//  Rakotonirina Eric Niaina
//  Rahajarivelo Manambintsoa Miora Tahina
//  Copyright © 2017 Home. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    public static var level = 0
    public static let maxLevel = 5
    private var player = PlayerSprite()
    var previousUpdate: TimeInterval = 0
    
    var cam: SKCameraNode!
    var score: SKLabelNode!
    var kunais: SKLabelNode!
    
    var zombieKilled = 0
    
    var enemies = Set<ZombieSprite>()
    
    var enemySpawn:SKSpriteNode?;
    var playerSpawn:SKSpriteNode?;
    
    var goal:SKSpriteNode?;
    //bg for world limit
    var bg:SKSpriteNode?;
    
    var intro = true
    var win = false
    
    override func didMove(to view: SKView) {
        
        // The objective
        self.goal = self.childNode(withName: "//goal") as? SKSpriteNode
        self.goal?.physicsBody?.contactTestBitMask = 	0x00000001
        
        // The Ninja
        self.playerSpawn = self.childNode(withName: "//player_spawn") as? SKSpriteNode
        self.player.position = (self.playerSpawn?.position)!
        self.addChild(self.player)
        
        // The Camera
        cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam)
        let zoomInAction = SKAction.scale(to: 1.5, duration: 1)
        camera?.run(zoomInAction)
        runIntro(duration:10.0)
        
        let wait = SKAction.wait(forDuration: 10)
        let run = SKAction.run({
            // World limit
            self.bg = self.childNode(withName: "//bg") as? SKSpriteNode
            let zeroRange = SKRange(constantValue: 10.0)
            let playerLocationConstraint = SKConstraint.distance(zeroRange, to: self.player)
            let scaledSize = CGSize(width: self.size.width * (self.camera?.xScale)!, height: self.size.height * (self.camera?.yScale)!)
            let boardContentRect = self.bg?.calculateAccumulatedFrame()
            let xInset = min((scaledSize.width / 2), (boardContentRect?.width)! / 2)
            let yInset = min((scaledSize.height / 2), (boardContentRect?.height)! / 2)
            let insetContentRect = boardContentRect?.insetBy(dx: xInset, dy: yInset)
            let xRange = SKRange(lowerLimit: (insetContentRect?.minX)!, upperLimit: (insetContentRect?.maxX)!)
            let yRange = SKRange(lowerLimit: (insetContentRect?.minY)!, upperLimit: (insetContentRect?.maxY)!)
            let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
            levelEdgeConstraint.referenceNode = self.bg
            self.camera?.constraints = [playerLocationConstraint, levelEdgeConstraint]
        })
        self.run(SKAction.sequence([wait, run]))
        
        
        // The Score HUD
        score = SKLabelNode(fontNamed: "Chalkduster")
        score.text = "Score: 0"
        score.horizontalAlignmentMode = .right
        score.position = CGPoint(x: -200, y: 200)
        score.zPosition = 10
        kunais = SKLabelNode(fontNamed: "Chalkduster")
        kunais.text = "Kunais: " + String(format: "%02d", self.player.kunais)
        kunais.position = CGPoint(x:0, y:200)
        kunais.zPosition = 10
        cam.addChild(kunais)
        cam.addChild(score)
        let levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Level: " + String(format: "%02d", GameScene.level)
        levelLabel.position = CGPoint(x:200, y:200)
        levelLabel.zPosition = 10
        cam.addChild(levelLabel)
        
        // The Zombies
        self.enemySpawn = self.childNode(withName: "//enemy_spawn") as? SKSpriteNode
        generateZombie()
        
        // Collision detection
        physicsWorld.contactDelegate = self
    }
    
    func runIntro(duration:Double) {
        let wait = SKAction.wait(forDuration: duration * 0.3)
        let camIn = SKAction.move(to: (goal?.position)!, duration: duration * 0.3)
        let outro = SKAction.move(to: player.position, duration: duration * 0.3)
        let run = SKAction.run({
            self.intro = false
        })
        camera?.run(SKAction.sequence([camIn, wait,outro, run]))
    }
    
    override func keyDown(with event: NSEvent) {
        if intro{
            return;
        }
        
        switch event.keyCode {
        case 6:
            self.player.stateMachine.enter(ThrowingState.self)
            break
        case 49:
            self.player.stateMachine.enter(AttackingState.self)
            break
        case 126:
            self.player.stateMachine.enter(JumpingState.self)
            break
            
        case 123:
            self.player.backward = true
            break
            
        case 124:
            self.player.forward = true;
            break
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func keyUp(with event: NSEvent) {
        if intro {
            return;
        }
        
        switch event.keyCode {
        case 6:
            self.player.stateMachine.enter(IdleState.self)
            kunais.text = "Kunais: " + String(format: "%02d", self.player.kunais)
            break
        case 126:
            break
        case 123:
            self.player.backward = false
            break
            
        case 124:
            self.player.forward = false;
            break
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.player.update(currentTime: currentTime)
        for enemy in self.enemies {
            enemy.update(currentTime: currentTime)
            if ((enemy.parent) == nil) {
                self.enemies.remove(enemy)
                zombieKilled += 1
                score.text = "Score: " + String(format: "%02d", zombieKilled)
            }
        }
        
        if(player.stateMachine.currentState is DyingState || player.position.y < -player.size.height - 1000) {
            goToGameOver()
        }
    }
    
    
    func generateZombie() {
        if((self.enemySpawn) != nil){
            let wait = SKAction.wait(forDuration: 10)
            let run = SKAction.run({
                if !self.win {
                    let zombie = ZombieSprite(player: self.player)
                    zombie.position = (self.enemySpawn?.position)!
                    self.addChild(zombie)
                    self.enemies.insert(zombie)
                }
            })
            self.run(SKAction.repeatForever(SKAction.sequence([wait, run])))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "kunai" {
            // Always remove kunai after being used
            (contact.bodyA.node as! KunaiSprite).removeKunai()
        }
        if contact.bodyB.node?.name == "kunai" {
            // Always remove kunai after being used
            (contact.bodyB.node as! KunaiSprite).removeKunai()
        }
        
        if contact.bodyA.node?.name == "kunai" && contact.bodyB.node?.name == "zombie" {
            self.swordAttackLogic(enemy: (contact.bodyB.node as! ZombieSprite), weapon: (contact.bodyA.node as! KunaiSprite))
        }
        if contact.bodyA.node?.name == "zombie" && contact.bodyB.node?.name == "kunai" {
            self.swordAttackLogic(enemy: (contact.bodyA.node as! ZombieSprite), weapon: (contact.bodyB.node as! KunaiSprite))
        }
        
        // Zombie Attack
        if contact.bodyA.node?.name == "ninja" && contact.bodyB.node?.name == "zombie" {
            self.attackLogic(enemy: (contact.bodyB.node as! ZombieSprite), player: (contact.bodyA.node as! PlayerSprite))
        }
        if contact.bodyA.node?.name == "zombie" && contact.bodyB.node?.name == "ninja" {
            self.attackLogic(enemy: (contact.bodyA.node as! ZombieSprite), player: (contact.bodyB.node as! PlayerSprite))
        }
        
        // Player Attack
        if contact.bodyA.node?.name == "sword" && contact.bodyB.node?.name == "zombie" {
            self.swordAttackLogic(enemy: (contact.bodyB.node as! ZombieSprite), weapon: (contact.bodyA.node as! SwordSprite))
        }
        if contact.bodyA.node?.name == "zombie" && contact.bodyB.node?.name == "sword" {
            self.swordAttackLogic(enemy: (contact.bodyA.node as! ZombieSprite), weapon: (contact.bodyB.node as! SwordSprite))
        }
        
        // Player Wins
        if contact.bodyA.node?.name == "ninja" && contact.bodyB.node?.name == "goal" {
            self.goToNextLevel()
        }
        if contact.bodyA.node?.name == "goal" && contact.bodyB.node?.name == "ninja" {
            self.goToNextLevel()
        }
        
        // Player got powerup
        if contact.bodyA.node?.name == "ninja" && contact.bodyB.node?.name == "powerup" {
            self.player.addPowerUp()
            kunais.text = "Kunais: " + String(format: "%02d", self.player.kunais)
            contact.bodyB.node?.removeFromParent()
        }
        if contact.bodyA.node?.name == "powerup" && contact.bodyB.node?.name == "ninja" {
            self.player.addPowerUp()
            kunais.text = "Kunais: " + String(format: "%02d", self.player.kunais)
            contact.bodyB.node?.removeFromParent()
        }
    }
    
    func swordAttackLogic(enemy:ZombieSprite, weapon: SKNode) {
        self.run(SKAction.playSoundFileNamed("hit.wav", waitForCompletion: true))
        enemy.attackedBy(node: weapon)
    }
    
    func attackLogic(enemy:ZombieSprite, player: PlayerSprite) {
        let preWait = SKAction.wait(forDuration: 0.9)
        
        let attack = SKAction.run({
            enemy.stateMachine?.enter(AttackingZombieState.self)
            if(enemy.intersects(player) && !(enemy.stateMachine?.currentState is DyingZombieState)) {
                player.stateMachine?.enter(DyingState.self)
            }
        })
        let attackSeq = SKAction.sequence([preWait, attack])
        self.run(attackSeq, completion: {
            print ("post zombie attack")
        })
    }
    
    func goToNextLevel() {
        print ("Goal")
        self.run(SKAction.playSoundFileNamed("menu_hit.wav", waitForCompletion: true))
        let wait = SKAction.wait(forDuration: 1.5)
        // Show Winner Message
        let msg = SKLabelNode(fontNamed: "Chalkduster")
        msg.text = "Yeah!!!!!!!"
        msg.position = CGPoint(x: 0, y: 200)
        msg.xScale = self.player.xScale
        player.addChild(msg)
        // Kill all zombies
        for enemy in self.enemies {
            enemy.stateMachine?.enter(DyingZombieState.self)
        }
        
        let run = SKAction.run({
            // Change scene
            GameScene.level += 1;
            var levelName = "Level_" + String(format: "%02d", GameScene.level)
            if(GameScene.level > GameScene.maxLevel) {
                GameScene.level = 0
                levelName = "WinningScene"
            }
            self.removeAllActions()
            let scene = SKScene(fileNamed: levelName)
            let transition = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(scene!, transition: transition)
        })
        self.run(SKAction.sequence([wait, run]))
    }
    
    func goToGameOver() {
        print ("GameOver")
        let scene = SKScene(fileNamed: "GameOverScene")
        let transition = SKTransition.fade(withDuration: 1)
        view?.presentScene(scene!, transition: transition)
    }
}
