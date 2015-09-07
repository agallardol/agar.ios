//
//  GameTools.swift
//  AGAR.IOS
//
//  Created by Alfredo Gallardo on 16-06-15.
//  Copyright (c) 2015 Agallardol. All rights reserved.
//

import SpriteKit

class GameTools
{
    let DefaultFeedRadius: CGFloat = 20.0;
    static func RandomPoint(bounds: CGRect)->CGPoint
    {
        var mod = Int(arc4random()) % Int(bounds.width);
        var xvalue = Int(bounds.minX) + mod;
        
        mod = Int(arc4random()) % Int(bounds.height);
        var yvalue = Int(bounds.minY) + mod;
        
        return CGPoint(x: xvalue, y: yvalue);

    
    }
    
    static func centerOnNode(node: SKNode)->Void
    {
        var cameraPositionInScene: CGPoint = node.scene!.convertPoint(node.position, fromNode: node.parent!);
        node.parent!.position = CGPointMake(node.parent!.position.x - cameraPositionInScene.x, node.parent!.position.y - cameraPositionInScene.y);
    }
    
     struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let Player       : UInt32 = 1
        static let Enemy    : UInt32 = 2
        static let Feed   : UInt32 = 3
    }
}