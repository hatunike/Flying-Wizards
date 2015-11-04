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
        
        if let spriteView = self.view as? SKView {
            
            let flyingScene = FlyingScene(size:spriteView.frame.size)
            
            if motionManager.deviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = 0.01
                
                motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data:CMDeviceMotion?, error:NSError?) -> Void in
                    
                    flyingScene.handleRotation(data)
                })
                
            }
        
            spriteView.showsDrawCount = true
            spriteView.showsFPS = true
            spriteView.showsNodeCount = true

            //spriteView.presentScene(MenuScene(size:spriteView.frame.size))
            spriteView.presentScene(flyingScene)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

