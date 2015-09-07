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
    static let MIN_SPEED: CGFloat = 5.0;
    static let MAX_SPEED: CGFloat = 35.0
    static let FEED_BONUS: CGFloat = 0.5;
    
    static let MAX_SIZE: CGFloat = 450;
    static let MAX_SIZE_USING_FEED: CGFloat = 200;
    
    static let DEFAULT_SIZE: CGFloat = 40.0;
    static let FONT_LIMIT_SIZE: CGFloat = 40;
    static let DEFAULT_STROKE_COLOR: UIColor = UIColor(red: 236.0 / 255, green: 206.0 / 255, blue: 118.0 / 255, alpha: 1.0);
    static let DEFAULT_FILL_COLOR: UIColor = UIColor(red: 86.0 / 255, green: 38.0 / 255, blue: 55.0 / 255, alpha: 1.0);
    
    static let WIGGLE_ANIMATION_KEY: String = "wiggle"
  
    func circleSpeed() -> CGFloat
    {
        var xxx = (Circle.MIN_SPEED - Circle.MAX_SPEED)/(Circle.MAX_SIZE - Circle.DEFAULT_SIZE)
        return xxx * self.radius + Circle.MAX_SPEED - Circle.DEFAULT_SIZE * xxx;
    }
    var radius: CGFloat {
        didSet {
            self.path = Circle.path(self.radius)
            /*self.physicsBody = SKPhysicsBody(circleOfRadius: self.radius);
            self.physicsBody?.usesPreciseCollisionDetection = true
            self.physicsBody?.dynamic = true;
            self.lineWidth = 2.0*/
            //self.physicsBody
        }
    }
    func JellyAnimation()->Void
    {
        let wiggleInX = SKAction.scaleXTo(1.03, duration: 0.2)
        let wiggleOutX = SKAction.scaleXTo(1.0, duration: 0.2)
        let wiggleInY = SKAction.scaleYTo(1.03, duration: 0.2)
        let wiggleOutY = SKAction.scaleYTo(1.0, duration: 0.2)
        let wiggle = SKAction.sequence([wiggleInX, wiggleOutX, wiggleInY, wiggleOutY])
        let repeatedWiggle = SKAction.repeatActionForever(wiggle)
        self.runAction(repeatedWiggle, withKey: PlayerCircle.WIGGLE_ANIMATION_KEY)
    }
    init(radius: CGFloat, position: CGPoint) {
        self.radius = radius
        
        super.init()
        
        self.path = Circle.path(self.radius)
        self.position = position
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.radius);
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.dynamic = true;
        self.lineWidth = 2.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func path(radius: CGFloat) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddArc(path, nil, CGFloat(0.0), CGFloat(0.0), radius, CGFloat(0.0), CGFloat(2.0 * M_PI), true)
        return path;
    }
    func EatFeedAnimation()->Void
    {
        let wiggleInX = SKAction.scaleXTo(1.1, duration: 0.3)
        let wiggleOutX = SKAction.scaleXTo(1.0, duration: 0.3)
        let wiggleInY = SKAction.scaleYTo(1.1, duration: 0.3)
        let wiggleOutY = SKAction.scaleYTo(1.0, duration: 0.2)
        let wiggle = SKAction.sequence([wiggleInX, wiggleOutX, wiggleInY, wiggleOutY])
        self.runAction(wiggle)
    }
    static func getRandomColor() ->  UIColor
    {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
    }

    func EatFeed(feed : FeedCircle)->Void
    {
        feed.removeFromParent();
        
        
        if(self.radius < PlayerCircle.MAX_SIZE_USING_FEED)
        {
            self.GrowUp(PlayerCircle.FEED_BONUS);
        }
        
        Playing.Feeds.remove(feed);
    }
    func GrowUp(bonus: CGFloat)->Void
    {
        self.radius += bonus;
        /*
        if (self.circleSpeed() - bonus >= PlayerCircle.MIN_SPEED){
            self.circleSpeed -= bonus;
        }*/
        self.EatFeedAnimation()
    }
    func EatEnemy(enemy: Enemy)->Void
    {
        enemy.removeFromParent();
        self.GrowUp(enemy.radius / 2);
    }
}
