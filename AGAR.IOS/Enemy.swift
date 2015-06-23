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
    var World: SKShapeNode? = nil
    var Player: SKShapeNode? = nil
    
    convenience init(world: SKShapeNode, player: SKShapeNode)
    {
        self.init(radius: Enemy.DEFAULT_ENEMY_SIZE, world: world, player: player, fillColor: Circle.getRandomColor(), strokeColor: Circle.getRandomColor());
    }
    
    convenience init(world: SKShapeNode, player: SKShapeNode, fillColor: UIColor, strokeColor: UIColor)
    {
        self.init(radius: Enemy.DEFAULT_ENEMY_SIZE, world: world, player: player, fillColor: fillColor, strokeColor: strokeColor);
    }
    
    init(radius: CGFloat, world: SKShapeNode, player: SKShapeNode, fillColor: UIColor, strokeColor: UIColor)
    {
        self.enemySpeed = PlayerCircle.MIN_PLAYER_SPEED;
        self.World = world
        self.Player = player
        
        super.init(radius: radius, position: GameTools.RandomPoint(self.World!.frame))
        
        //Color
        self.strokeColor = strokeColor;
        self.fillColor = fillColor;
        self.antialiased = true;
        self.name = "enemy";
        self.zPosition = 2;
        self.physicsBody?.categoryBitMask = GameTools.PhysicsCategory.Enemy;
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
        
        var moveEnemy = SKAction.followPath( GetRandomPath(self.World!.frame, source: self, target: self.Player!), asOffset: false, orientToPath: true, duration: 8.0);
        self.runAction(moveEnemy, completion: {self.OnMoveEnemyEnd(self.World!.frame, source: self, target: self.Player!)});

    }
    
    func GetRandomPath(frame: CGRect, source: SKShapeNode, target: SKShapeNode) -> CGPath
    {
        var randomPath: UIBezierPath = UIBezierPath();
        randomPath.moveToPoint(source.position);
        randomPath.addCurveToPoint(target.position, controlPoint1: RandomPoint(frame), controlPoint2: RandomPoint(frame));
        return randomPath.CGPath;
    }
    //peneeeee
    func RandomPoint(bounds: CGRect)->CGPoint
    {
        var mod = Int(arc4random()) % Int(CGRectGetMaxX(bounds));
        var xvalue = Int(bounds.minX) + mod;
        
        mod = Int(arc4random()) % Int(CGRectGetMaxY(bounds));
        var yvalue = Int(bounds.minY) + mod;
        return CGPoint(x: xvalue, y: yvalue);
    }
    
    func OnMoveEnemyEnd(frame: CGRect, source: SKShapeNode, target: SKShapeNode) -> Void
    {
        var moveEnemy = SKAction.followPath( GetRandomPath(self.World!.frame, source: self, target: self.Player!), asOffset: false, orientToPath: true, duration: 8.0);
        self.runAction(moveEnemy, completion: {self.OnMoveEnemyEnd(self.World!.frame, source: self, target: self.Player!)});
    }
    
    func EatFeed(feed: SKShapeNode)->Void
    {
        feed.removeFromParent();
        
        if(self.radius < Enemy.MAX_ENEMY_SIZE_USING_FEED)
        {
            self.GrowUp(Enemy.FEED_BONUS);
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
