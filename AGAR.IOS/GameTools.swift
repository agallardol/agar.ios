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
    
    static func RandomPointScene(bounds: CGRect)->CGPoint
    {
        var mod = Int(arc4random()) % Int(bounds.width);
        var xvalue = mod - Int(bounds.width / 2);
        
        mod = Int(arc4random()) % Int(bounds.height);
        var yvalue = mod - Int(bounds.height / 2);
        
        
        return CGPoint(x: (xvalue ), y: (yvalue ));
        
        
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
    static let Planets: [String] = ["sunDot@2x1.png","sunDot@2x2.png","sunDot@2x3.png","sunDot@2x4.png","sunDot@2x5.png","sunDot@2x6.png","satelliteL.png","asteroid2.png","redAsteroidL.png","greenAsteroidL.png"]
    
    static func getRandomPlaneSprite()->String{
        return GameTools.Planets[Int(arc4random() % 4)]
    }
    enum GameState {
        case Playing, Lose, Win
    }
}