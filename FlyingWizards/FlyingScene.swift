//
//  FlyingScene.swift
//  FlyingWizards
//
//  Created by Charles Hart on 11/3/15.
//  Copyright © 2015 busybusy. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion


enum FlyingSceneNodes : String {
    case FlyingWizard
    case B0
    case B0Flipped
    case GriffTower
    case SlythTower
    case RavenTower
    case HuffTower
    
}

class FlyingScene: SKScene{
    
    var num = 1
    var fgNum = 1
    var contentLoaded = false
    var scrollingSpeed:NSTimeInterval = 5
    
    override init(size:CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createSceneContents() {
        
        backgroundColor = SKColor.darkGrayColor()
        
        addChild(flyingWizardNode())
        
        //Must add b0 before b0Flipped
        
        addChild(backgroundNode())
        addChild(backgroundFlippedNode())
        
        //towers
        addChild(griffTower())
        addChild(huffTower())
        addChild(slythTower())
        addChild(ravenTower())
        
        
    }
    
    override func didMoveToView(view: SKView) {
        if !contentLoaded {
            createSceneContents()
            contentLoaded = true
            
            //Move both by rate -points/sec
            animateWizard()
            moveBackground0Nodes()
            moveForGroundNodes()
        }
    }
    
    func animateWizard() {
        
        var gifTextures: [SKTexture] = [];
        
        for i in 1...4 {
            gifTextures.append(SKTexture(imageNamed: "flying_wizard2-\(i).png"));
        }
        if let wizardNode = childNodeWithName(FlyingSceneNodes.FlyingWizard.rawValue) {
            wizardNode.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(gifTextures, timePerFrame: 0.125)));
        }
        
    }
    func flyingWizardNode() -> SKNode {
        let wizard = SKSpriteNode(imageNamed: "flying_wizard2-0.png")
        
        wizard.yScale = 1.0
        wizard.xScale = 1.0
        wizard.position = CGPointMake(75, frame.size.height - 100)
        wizard.name = FlyingSceneNodes.FlyingWizard.rawValue
        wizard.zPosition = 1
        return wizard
    }
    
    func backgroundNode() -> SKNode {
        let bgNode = SKSpriteNode(imageNamed: "bg0.png")
        bgNode.size = frame.size
        bgNode.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        bgNode.zPosition = -1
        bgNode.name = FlyingSceneNodes.B0.rawValue
        
        return bgNode
    }
    
    func backgroundFlippedNode() -> SKNode {
        let bgNode = SKSpriteNode(imageNamed: "bg0-flipped.png")
        
        if let otherNode = childNodeWithName(FlyingSceneNodes.B0.rawValue){
            
            bgNode.position.x = otherNode.position.x+otherNode.frame.width
            bgNode.position.y = otherNode.position.y
        }
        bgNode.size = frame.size
        bgNode.zPosition = -1
        bgNode.name = FlyingSceneNodes.B0Flipped.rawValue
        
        return bgNode
        
    }
    
    //added towers
    func griffTower() ->SKNode {
        let t1 = SKSpriteNode(imageNamed: "griffindor_tower.png")
            t1.size = frame.size
            t1.position = CGPointMake(frame.size.width/2, frame.size.height/4)
            t1.position.x = -10
            t1.zPosition = 0
            t1.name = FlyingSceneNodes.GriffTower.rawValue
            
        return t1
        
    }
    
    func slythTower() ->SKNode {
        let t1 = SKSpriteNode(imageNamed: "slytherin_tower.png")
        
        if let otherNode = childNodeWithName(FlyingSceneNodes.GriffTower.rawValue){
            t1.position.x = otherNode.position.x+otherNode.frame.width*2
            t1.position.y = otherNode.position.y + 14
        }
        
        t1.size = frame.size
        t1.zPosition = 0
        t1.name = FlyingSceneNodes.SlythTower.rawValue
        
        return t1
        
    }
    func huffTower() ->SKNode {
         let t1 = SKSpriteNode(imageNamed: "hufflepuff_tower.png")
        
        if let otherNode = childNodeWithName(FlyingSceneNodes.GriffTower.rawValue){
            t1.position.x = otherNode.position.x+otherNode.frame.width
            t1.position.y = otherNode.position.y + 8
        }

        
        t1.size = frame.size
        t1.zPosition = 0
        t1.name = FlyingSceneNodes.HuffTower.rawValue
        
        return t1
        
    }
    func ravenTower() ->SKNode {
        let t1 = SKSpriteNode(imageNamed: "ravenclaw_tower.png")
        
        if let otherNode = childNodeWithName(FlyingSceneNodes.GriffTower.rawValue){
            t1.position.x = otherNode.position.x+otherNode.frame.width*3
            t1.position.y = otherNode.position.y + 12.5
        }

        t1.size = frame.size
        t1.zPosition = 0
        t1.name = FlyingSceneNodes.RavenTower.rawValue
        
        return t1
        
    }

    
    func handleRotation(data:CMDeviceMotion?) {
        
        if let wizardNode = childNodeWithName(FlyingSceneNodes.FlyingWizard.rawValue) {
            if data!.gravity.y < 0 {
                let rotation = -CGFloat(-atan2(data!.gravity.x, data!.gravity.y) - M_PI)
                
                let verticalMax = 12.0
                let adjustedVertical = CGFloat(verticalMax * -data!.gravity.x)
                
                let rotationAction = SKAction.rotateToAngle(rotation, duration: 0.01, shortestUnitArc: true)
                let moveAction = SKAction.moveByX(0, y: adjustedVertical, duration: 0.01)
                
                wizardNode.runAction(SKAction.sequence([rotationAction, moveAction]))
            }
        }
    }
    func moveForGroundNodes() {
        if let griffTower = childNodeWithName(FlyingSceneNodes.GriffTower.rawValue), huffTower = childNodeWithName(FlyingSceneNodes.HuffTower.rawValue), slythTower = childNodeWithName(FlyingSceneNodes.SlythTower.rawValue), ravenTower = childNodeWithName(FlyingSceneNodes.RavenTower.rawValue){
            
            let moveAction = SKAction.moveByX(-griffTower.frame.width*(2.0), y: 0, duration: scrollingSpeed)
            let moveAction2 = SKAction.moveByX(-huffTower.frame.width*(2.0), y: 0, duration: scrollingSpeed)
            let moveAction3 = SKAction.moveByX(-slythTower.frame.width*(2.0), y: 0, duration: scrollingSpeed)
            let moveAction4 = SKAction.moveByX(-ravenTower.frame.width*(2.0), y: 0, duration: scrollingSpeed)
            
            griffTower.runAction(moveAction, completion: { () -> Void in
                if self.fgNum == 1 {
                    griffTower.position.x += self.frame.width * 4
                    self.fgNum += 1
                    print(self.fgNum)
                }
                if self.fgNum == 2 {
                    huffTower.position.x += self.frame.width * 4
                    self.fgNum += 1
                }
                if self.fgNum == 3 {
                    self.fgNum += 1
                }
                else {
                    slythTower.position.x += self.frame.width * 4
                    ravenTower.position.x += self.frame.width * 4
                    self.fgNum -= 3
                    print(self.fgNum)
                }
                
                self.moveForGroundNodes()
            })
            huffTower.runAction(moveAction2, completion: { () -> Void in
                
            })
            slythTower.runAction(moveAction3, completion: { () -> Void in
                
                
            })
            ravenTower.runAction(moveAction4, completion: { () -> Void in
                
                
            })
        }
    }
    
    func moveBackground0Nodes() {
        
        
        if let b0 = childNodeWithName(FlyingSceneNodes.B0.rawValue), b0Flipped = childNodeWithName(FlyingSceneNodes.B0Flipped.rawValue){
            let moveAction = SKAction.moveByX(-b0.frame.width*(1.0), y: 0, duration: scrollingSpeed * 5)
            let moveAction2 = SKAction.moveByX(-b0Flipped.frame.width*(1.0), y: 0, duration: scrollingSpeed * 5)
            
            
            
            b0.runAction(moveAction, completion: { () -> Void in
//                print("Before b0-x=\(b0.position.x) b0-width = \(b0.frame.width)")
//                print("Before b0Flipped-x=\(b0Flipped.position.x) b0Flipped-width = \(b0Flipped.frame.width)")
                
                if self.num % 2 == 1 {
                    //print(self.num)
                    b0.position.x += b0Flipped.frame.size.width*2
                    self.num = self.num+1
                    //print(self.num)
                    
                }
                else {
                    b0Flipped.position.x += b0.frame.size.width*2
                    self.num = self.num-1
                    //print(self.num)
                }
                
                //print("After b0-x=\(b0.position.x) b0-width = \(b0.frame.width)")
                //print("After b0Flipped-x=\(b0Flipped.position.x) b0Flipped-width = \(b0Flipped.frame.width)")
                
                
                self.moveBackground0Nodes()
            })
            
            b0Flipped.runAction(moveAction2, completion: { () -> Void in
                
            })
            

        }
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Handle if no 3DTouch
        if let touch = touches.first {
            
            let maximum = touch.maximumPossibleForce
            let maximumSpeed:CGFloat = 15

            if maximum == 0 {
                if let bgNode = childNodeWithName(FlyingSceneNodes.B0.rawValue), bgFlipped = childNodeWithName(FlyingSceneNodes.B0Flipped.rawValue),griffTower = childNodeWithName(FlyingSceneNodes.GriffTower.rawValue), huffTower = childNodeWithName(FlyingSceneNodes.HuffTower.rawValue), slythTower = childNodeWithName(FlyingSceneNodes.SlythTower.rawValue), ravenTower = childNodeWithName(FlyingSceneNodes.RavenTower.rawValue){
                    bgNode.runAction(SKAction.speedTo(maximumSpeed, duration: 3.0))
                    bgFlipped.runAction(SKAction.speedTo(maximumSpeed, duration: 3.0))
                    griffTower.runAction(SKAction.speedTo(maximumSpeed, duration: 3.0))
                    huffTower.runAction(SKAction.speedTo(maximumSpeed, duration: 3.0))
                    slythTower.runAction(SKAction.speedTo(maximumSpeed, duration: 3.0))
                    ravenTower.runAction(SKAction.speedTo(maximumSpeed, duration: 3.0))
                }
            }
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let bgNode = childNodeWithName(FlyingSceneNodes.B0.rawValue), bgFlipped = childNodeWithName(FlyingSceneNodes.B0Flipped.rawValue),griffTower = childNodeWithName(FlyingSceneNodes.GriffTower.rawValue), huffTower = childNodeWithName(FlyingSceneNodes.HuffTower.rawValue), slythTower = childNodeWithName(FlyingSceneNodes.SlythTower.rawValue), ravenTower = childNodeWithName(FlyingSceneNodes.RavenTower.rawValue){
            bgNode.runAction(SKAction.speedTo(1, duration: 1.0))
            bgFlipped.runAction(SKAction.speedTo(1, duration: 1.0))
            griffTower.runAction(SKAction.speedTo(1, duration: 1.0))
            huffTower.runAction(SKAction.speedTo(1, duration: 1.0))
            slythTower.runAction(SKAction.speedTo(1, duration: 1.0))
            ravenTower.runAction(SKAction.speedTo(1, duration: 1.0))
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            
            let force = touch.force
            let maximum = touch.maximumPossibleForce
            
            if maximum > 0 {
                let forcePressed:CGFloat = force / maximum
                
                let maximumSpeed:CGFloat = 30
                
                let speedToChangeTo = forcePressed * maximumSpeed
                
                
                if let bgNode = childNodeWithName(FlyingSceneNodes.B0.rawValue), bgFlipped = childNodeWithName(FlyingSceneNodes.B0Flipped.rawValue){
                    bgNode.runAction(SKAction.speedTo(speedToChangeTo, duration: 1.0))
                    bgFlipped.runAction(SKAction.speedTo(speedToChangeTo, duration: 1.0))
                }
                print("force applied  \(forcePressed)")
            }
        }
    }
    
}

