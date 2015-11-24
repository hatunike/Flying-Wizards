//
//  BludgerMovement.swift
//  FlyingWizards
//
//  Created by STUDENT #6 on 11/22/15.
//  Copyright © 2015 busybusy. All rights reserved.
//

import Foundation
import SpriteKit


class NodesMovement: SKScene {
    enum FlyingSceneNodes : String {
        case FlyingWizard
        case B0
        case B0Flipped
        case GriffTower
        case SlythTower
        case RavenTower
        case HuffTower
        
        case Bludger
    }
    
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
        
    }

    override func didMoveToView(view: SKView) {
    
    }

    func moveBludgerNode() {
        
        if let bludgerNode = childNodeWithName(FlyingSceneNodes.Bludger.rawValue), wizard = childNodeWithName(FlyingSceneNodes.FlyingWizard.rawValue)
        {
            //let moveAction = SKAction.moveByX(-bludgerNode.frame.width*(1.0), y: 0, duration: scrollingSpeed)
            //moveAction = SKAction.moveToY(wizard.position.y, duration: 0.5)
            let moveX = SKAction.moveToX((frame.width-50), duration: 2)
            let moveY = SKAction.moveToY((wizard.position.y), duration: 2)
            //let move = followTheWizard(bludgerNode)
            
            let followWizard = SKAction.group([moveX, moveY])
            let moveUp = SKAction.moveByX(0, y: 50, duration: 1.5)
            let wizardChase = SKAction.sequence([followWizard,moveUp])
            
            while bludgerNode.frame.origin.x > -self.frame.width{
                bludgerNode.runAction(wizardChase, completion: {
                    self.launchBludgerToWizard(bludgerNode)
                })
                
                
            }
            bludgerNode.runAction(SKAction.moveByX(bludgerNode.frame.origin.x + self.frame.size.width * 2, y: 0, duration: 0))
            bludgerNode.runAction(SKAction.moveToY(self.randomYCoordinate(), duration: 0))
            self.moveBludgerNode()
        }
        
    }
    
    func launchBludgerToWizard(bludger:SKNode) {
        
        let wizard = childNodeWithName(FlyingSceneNodes.FlyingWizard.rawValue)
        let vector = CGVector(dx: (wizard!.frame.origin.x*10 - bludger.frame.origin.x*10), dy: (wizard!.frame.origin.y*10 - bludger.frame.origin.y*10))
        let impulseToWizard = bludger.physicsBody?.applyImpulse(vector)
        
        impulseToWizard
    }
    
    func randomYCoordinate() -> CGFloat {
        
        return 200.0
    }
    
    
    func followTheWizard(bludger:SKNode) -> SKAction{
        let wizard = childNodeWithName(FlyingSceneNodes.FlyingWizard.rawValue)
        
        //(x2-x1,y2-y1) x1 bludge x2 wizard
        //Normalize vectore
        
        let vector = CGVector(dx: (wizard!.frame.origin.x - bludger.frame.origin.x), dy: (wizard!.frame.origin.y - bludger.frame.origin.y))
        
        let normVector = normalizeVector(vector)
        let angleOfVector = vectorAngle(normVector)
        
        let pi:CGFloat = 3.14159265435
        
        if abs(angleOfVector) > (pi / 2.0) {
            let vectorFollow = SKAction.moveBy(multiplyByScalor(normVector, scale: 2.0), duration: 0.005)
            print("inside \(angleOfVector)")
            
            return SKAction.sequence([vectorFollow])
        } else {
            var vectorLeaveScreen:SKAction
            
            if bludger.frame.origin.x < -bludger.frame.size.width {
                vectorLeaveScreen = SKAction.moveByX(frame.size.width + bludger.frame.size.width, y: 0, duration: 0)
                
            } else {
                vectorLeaveScreen = SKAction.moveBy(CGVector(dx: -1,dy: 0), duration: 0.005)
            }
            print("outside \(angleOfVector)")
            
            return SKAction.sequence([vectorLeaveScreen])
        }
    }
    
    
    func normalizeVector (vector:CGVector) -> CGVector {
        let length = vectorLength(vector)
        if length == 0 {
            return CGVectorMake(0, 0)
        }
        
        let scale = 1.0 / length
        
        return multiplyByScalor(vector, scale: scale)
    }
    
    func multiplyByScalor (vector:CGVector, scale:CGFloat) -> CGVector{
        return CGVectorMake(vector.dx * scale, vector.dy * scale)
        
    }
    
    func vectorLength(vector:CGVector) ->  CGFloat {
        return sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
    }
    
    //    CGVectorAngle(CGVector vector)
    //    {
    //    return atan2(vector.dy, vector.dx);
    //    }
    
    func vectorAngle(vector:CGVector) -> CGFloat {
        return atan2(vector.dy, vector.dx)
    }
}