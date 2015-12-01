//
//  CGVector+Additions.swift
//  FlyingWizards
//
//  Created by Charles Hart on 11/24/15.
//  Copyright © 2015 busybusy. All rights reserved.
//

import UIKit


extension CGVector {
    func normalizeVector () -> CGVector {
        let length = vectorLength()
        if length == 0 {
            return CGVectorMake(0, 0)
        }
        
        let scale = 1.0 / length
        
        return multiplyByScalor(scale)
    }
    
    func multiplyByScalor (scale:CGFloat) -> CGVector{
        return CGVectorMake(self.dx * scale, self.dy * scale)
    }
    
    func vectorLength() ->  CGFloat {
        
        return sqrt(self.dx * self.dx + self.dy * self.dy)
    }
    
    
    func vectorAngle() -> CGFloat {
        return atan2(self.dy, self.dx)
    }
    
}