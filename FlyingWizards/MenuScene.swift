//
//  MenuScene.swift
//  FlyingWizards
//
//  Created by Charles Hart on 11/3/15.
//  Copyright © 2015 busybusy. All rights reserved.
//

import UIKit
import SpriteKit

enum MenuNodes : String {
    case Button0
    case MenuTitle
}

class MenuScene: SKScene {

    var contentLoaded = false
    var target: AnyObject?
    var action: Selector?
    var playButtonPressed:Bool = false
    
    override init(size:CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createSceneContents() {
        
        backgroundColor = SKColor.darkGrayColor()
        
        addChild(title())
        
        addChild(menuButton0())
        
        
    }
    
    override func didMoveToView(view: SKView) {
        if !contentLoaded {
            createSceneContents()
            contentLoaded = true
        }
    }
    
    func title() -> SKNode {
        
        let title = SKLabelNode(text: "Flying Wizards")
        title.fontColor = SKColor.whiteColor()
        title.fontSize = 44
        title.position = CGPointMake(frame.size.width/2, frame.size.height - 100)
        return title
    }
    
    func menuButton0() -> SKNode {
        
        let customButton = SKSpriteNode(color: UIColor.lightGrayColor(), size: CGSizeMake(100, 50))
        customButton.position = CGPointMake(frame.size.width/2, frame.size.height - 200)
        customButton.name = MenuNodes.Button0.rawValue
        
        return customButton
    }
    
    func addTarget(target:AnyObject?, action:Selector) {
        self.target = target
        self.action = action
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch?.locationInNode(self)
        
        let nodesAtPosition = nodesAtPoint(location!)
        
        if let node = nodesAtPosition.last where node.name == MenuNodes.Button0.rawValue {
            
            menuButtonPressed()
            
        }
    }
    
    func menuButtonPressed() {
        if let target1 = target, action1 = action where !playButtonPressed {
            playButtonPressed = true
            target1.performSelector(action1)
            target = nil
            action = nil
        }
    }

}
