//
//  PlayerCircle.swift
//  AGAR.IOS
//
//  Created by Alfredo Gallardo on 16-06-15.
//  Copyright (c) 2015 Agallardol. All rights reserved.
//

import SpriteKit

class PlayerCircle : Circle
{
    static let DEFAULT_PLAYER_SIZE: CGFloat = 40.0;
    static let MIN_PLAYER_SPEED: CGFloat = 1;
    static let MAX_PLAYER_SIZE: CGFloat = 1000;
    static let MAX_PLAYER_SIZE_USING_FEED: CGFloat = 200;
    static let FONT_LIMIT_SIZE: CGFloat = 40;
    static let DEFAULT_PLAYER_STROKE_COLOR: UIColor = UIColor(red: 236.0 / 255, green: 206.0 / 255, blue: 118.0 / 255, alpha: 1.0);
    static let DEFAULT_PLAYER_FILL_COLOR: UIColor = UIColor(red: 86.0 / 255, green: 38.0 / 255, blue: 55.0 / 255, alpha: 1.0);    var playerSpeed: CGFloat;
    static let FEED_BONUS: CGFloat = 5.0;
    static let WIGGLE_ANIMATION_KEY: String = "wiggle"
    var playerLabel: SKLabelNode? = nil;
    convenience init(frame: CGRect)
    {
        self.init(radius: PlayerCircle.DEFAULT_PLAYER_SIZE, frame: frame, fillColor: PlayerCircle.DEFAULT_PLAYER_FILL_COLOR, strokeColor: PlayerCircle.DEFAULT_PLAYER_STROKE_COLOR);
    }

    convenience init(frame: CGRect, fillColor: UIColor, strokeColor: UIColor)
    {
        self.init(radius: PlayerCircle.DEFAULT_PLAYER_SIZE, frame: frame, fillColor: fillColor, strokeColor: strokeColor);
    }
    
    init(radius: CGFloat, frame: CGRect, fillColor: UIColor, strokeColor: UIColor)
    {
        self.playerSpeed = PlayerCircle.MIN_PLAYER_SPEED;

        super.init(radius: radius, position: GameTools.RandomPoint(frame))
        
        //Color
        self.strokeColor = strokeColor;
        self.fillColor = fillColor;
        self.antialiased = true;
        self.name = "player";
        self.zPosition = 2;
        self.physicsBody?.categoryBitMask = GameTools.PhysicsCategory.Player;
        self.physicsBody?.contactTestBitMask = GameTools.PhysicsCategory.Feed;
        self.physicsBody?.collisionBitMask = GameTools.PhysicsCategory.None;
        
        self.playerLabel = SKLabelNode();
        self.playerLabel!.name = "playerLabel";
        self.playerLabel!.text = "Me";
        self.playerLabel!.fontSize = 25;
        self.playerLabel!.fontColor = SKColor(red: 236.0 / 255,
            green: 206.0 / 255,
            blue: 118.0 / 255,
            alpha: 1.0);
        self.playerLabel!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
        self.playerLabel!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
        self.playerLabel!.userInteractionEnabled = true;
        self.addChild(playerLabel!);
        //self.JellyAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    func EatFeed(feed: SKShapeNode)->Void
    {
        feed.removeFromParent();
        
        if(self.radius < PlayerCircle.MAX_PLAYER_SIZE_USING_FEED)
        {
            self.GrowUp(PlayerCircle.FEED_BONUS);
        }
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
    func GrowUp(bonus: CGFloat)->Void
    {
        self.radius += bonus;
        self.EatFeedAnimation()
    }
}