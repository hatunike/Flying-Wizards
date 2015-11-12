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
}

class FlyingScene: SKScene{
    
    var num = 1
    var contentLoaded = false
    var scrollingSpeed:NSTimeInterval = 10
    
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
        
    }
    
    override func didMoveToView(view: SKView) {
        if !contentLoaded {
            createSceneContents()
            contentLoaded = true
            
            //Move both by rate -points/sec
            animateWizard()
            moveBackground0Nodes()
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
    
    
    func moveBackground0Nodes() {
        
        
        if let b0 = childNodeWithName(FlyingSceneNodes.B0.rawValue), b0Flipped = childNodeWithName(FlyingSceneNodes.B0Flipped.rawValue) {
            let moveAction = SKAction.moveByX(-b0.frame.width*(1.0), y: 0, duration: scrollingSpeed)
            let moveAction2 = SKAction.moveByX(-b0Flipped.frame.width*(1.0), y: 0, duration: scrollingSpeed)
            
            b0.runAction(moveAction, completion: { () -> Void in
                print("Before b0-x=\(b0.position.x) b0-width = \(b0.frame.width)")
                print("Before b0Flipped-x=\(b0Flipped.position.x) b0Flipped-width = \(b0Flipped.frame.width)")
                
                if self.num % 2 == 1 {
                    print(self.num)
                    b0.position.x += b0Flipped.frame.size.width*2-1
                    self.num = self.num+1
                    print(self.num)
                
                }
                else {
                    b0Flipped.position.x += b0.frame.size.width*2-1
                    self.num = self.num-1
                    print(self.num)
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
        
            scrollingSpeed = 1.0
        
        
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        scrollingSpeed = 10.0
    }
        
}

