//
//  Circle.swift
//  AGAR.IOS
//
//  Created by Alfredo Gallardo on 16-06-15.
//  Copyright (c) 2015 Agallardol. All rights reserved.
//

import SpriteKit

class Circle : SKShapeNode
{
    var radius: CGFloat {
        didSet {
            self.path = Circle.path(self.radius)
            //self.physicsBody
        }
    }
    
    init(radius: CGFloat, position: CGPoint) {
        self.radius = radius
        
        super.init()
        
        self.path = Circle.path(self.radius)
        self.position = position
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.radius);
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.dynamic = true;

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func path(radius: CGFloat) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddArc(path, nil, CGFloat(0.0), CGFloat(0.0), radius, CGFloat(0.0), CGFloat(2.0 * M_PI), true)
        return path;
    }

}
