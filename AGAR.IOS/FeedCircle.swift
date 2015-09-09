//
//  FeedCircle.swift
//  AGAR.IOS
//
//  Created by Alfredo Gallardo on 15-06-15.
//  Copyright (c) 2015 Agallardol. All rights reserved.
//

import SpriteKit

class FeedCircle : Circle
{
    static let DEFAULT_FEED_SIZE: CGFloat = 20.0;
    
    convenience init(frame: CGRect)
    {
        self.init(radius: FeedCircle.DEFAULT_FEED_SIZE, frame: frame);
    }
    
    init(radius: CGFloat, frame: CGRect)
    {
        super.init(radius: radius, position: GameTools.RandomPointScene(frame))
        self.strokeColor = UIColor(red: 236.0 / 255, green: 216.0 / 255, blue: 118.0 / 255, alpha: 1.0);
        //self.fillColor = UIColor(red: 1.0 / 255, green: 95.0 / 255, blue: 66.0 / 255, alpha: 1.0);
        self.addChild(SKSpriteNode(imageNamed: "asteroids.png"))
        self.antialiased = true;
        self.zPosition = 1;
        self.physicsBody?.categoryBitMask = GameTools.PhysicsCategory.Feed;
        
        setScale(0.1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
