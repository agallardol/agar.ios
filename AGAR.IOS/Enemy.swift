//
//  Enemy.swift
//  AGAR.IOS
//
//  Created by Mac 2 on 23-06-15.
//  Copyright (c) 2015 Agallardol. All rights reserved.
//

import SpriteKit

class Enemy : Circle
{
    static let DEFAULT_ENEMY_SIZE: CGFloat = 40.0;
    static let MIN_ENEMY_SPEED: CGFloat = 1;
    static let MAX_ENEMY_SIZE: CGFloat = 1000;
    static let MAX_ENEMY_SIZE_USING_FEED: CGFloat = 200;
    static let FONT_LIMIT_SIZE: CGFloat = 40;
    static let DEFAULT_ENEMY_STROKE_COLOR: UIColor = UIColor(red: 236.0 / 255, green: 206.0 / 255, blue: 118.0 / 255, alpha: 1.0);
    static let DEFAULT_ENEMY_FILL_COLOR: UIColor = UIColor(red: 86.0 / 255, green: 38.0 / 255, blue: 55.0 / 255, alpha: 1.0);
    var enemySpeed: CGFloat;
    static let FEED_BONUS: CGFloat = 5.0;
    static let WIGGLE_ANIMATION_KEY: String = "wiggle"
    var enemyLabel: SKLabelNode? = nil;
    
    convenience init(frame: CGRect)
    {
        self.init(radius: Enemy.DEFAULT_ENEMY_SIZE, frame: frame, fillColor: Circle.getRandomColor(), strokeColor: Circle.getRandomColor());
    }
    
    convenience init(frame: CGRect, fillColor: UIColor, strokeColor: UIColor)
    {
        self.init(radius: Enemy.DEFAULT_ENEMY_SIZE, frame: frame, fillColor: fillColor, strokeColor: strokeColor);
    }
    
    init(radius: CGFloat, frame: CGRect, fillColor: UIColor, strokeColor: UIColor)
    {
        self.enemySpeed = PlayerCircle.MIN_PLAYER_SPEED;
        
        super.init(radius: radius, position: GameTools.RandomPoint(frame))
        
        //Color
        self.strokeColor = strokeColor;
        self.fillColor = fillColor;
        self.antialiased = true;
        self.name = "enemy";
        self.zPosition = 2;
        self.physicsBody?.categoryBitMask = GameTools.PhysicsCategory.Player;
        self.physicsBody?.contactTestBitMask = GameTools.PhysicsCategory.Feed;
        self.physicsBody?.collisionBitMask = GameTools.PhysicsCategory.None;
        
        self.enemyLabel = SKLabelNode();
        self.enemyLabel!.name = "enemyLabel";
        self.enemyLabel!.text = "El Terrible Enemigo";
        self.enemyLabel!.fontSize = 25;
        self.enemyLabel!.fontColor = SKColor(red: 236.0 / 255,
            green: 206.0 / 255,
            blue: 118.0 / 255,
            alpha: 1.0);
        self.enemyLabel!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
        self.enemyLabel!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
        self.enemyLabel!.userInteractionEnabled = true;
        self.addChild(enemyLabel!);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
