//
//  ViewController.swift
//  FlyingWizards
//
//  Created by Charles Hart on 11/3/15.
//  Copyright © 2015 busybusy. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion


class ViewController: UIViewController {

    var motionManager = CMMotionManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerLost", name: "player lost", object: nil)
        
        if let spriteView = self.view as? SKView {
        
            spriteView.showsDrawCount = true
            spriteView.showsFPS = true
            spriteView.showsNodeCount = true
            
            spriteView.presentScene(menuScene(view.frame.size))
        }
        
        
    }
    
    func playerLost() {

        if let spriteView = self.view as? SKView {
            
            spriteView.showsDrawCount = true
            spriteView.showsFPS = true
            spriteView.showsNodeCount = true
            let fadeTransition = SKTransition.fadeWithDuration(1.0)
            spriteView.presentScene(menuScene(view.frame.size), transition: fadeTransition)
        
        }
    }
    
    func startGame() {
        if let spriteView = self.view as? SKView {
            
            let flyingScene = FlyingScene(size:spriteView.frame.size)
            
            if motionManager.deviceMotionAvailable {
                motionManager.stopDeviceMotionUpdates()
                
                motionManager.deviceMotionUpdateInterval = 0.01
                
                motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data:CMDeviceMotion?, error:NSError?) -> Void in
                    
                    flyingScene.handleRotation(data)
                })

                
                
            }
            
            spriteView.showsDrawCount = true
            spriteView.showsFPS = true
            spriteView.showsNodeCount = true
            let menu = MenuScene(size:spriteView.frame.size)
            menu.addTarget(self, action: "startGame")
            let fadeTransition = SKTransition.fadeWithDuration(1.0)
            spriteView.presentScene(flyingScene, transition: fadeTransition)
    
        }
    }
    
    func menuScene(size:CGSize)->SKScene {
        let menu = MenuScene(size:size)
        menu.addTarget(self, action: "startGame")
        return menu
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

