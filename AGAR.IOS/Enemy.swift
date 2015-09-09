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

    var enemyLabel: SKLabelNode? = nil;
    var World: SKShapeNode? = nil
    var Player: SKShapeNode? = nil
    
    convenience init(world: SKShapeNode, player: SKShapeNode)
    {
        var radius: CGFloat = CGFloat(Float(arc4random()) % 200) + Enemy.DEFAULT_SIZE / 2;
        self.init(radius: radius, world: world, player: player, fillColor: Circle.getRandomColor(), strokeColor: Circle.getRandomColor());
    }
    
    convenience init(world: SKShapeNode, player: SKShapeNode, fillColor: UIColor, strokeColor: UIColor)
    {
        var radius: CGFloat = CGFloat(Float(arc4random()) % 200) + Enemy.DEFAULT_SIZE / 2;
        self.init(radius: radius, world: world, player: player, fillColor: fillColor, strokeColor: strokeColor);
    }
    
    init(radius: CGFloat, world: SKShapeNode, player: SKShapeNode, fillColor: UIColor, strokeColor: UIColor)
    {
        
        self.World = world
        self.Player = player
        super.init(radius: radius, position: GameTools.RandomPointScene(self.World!.frame))
        
        //self.circleSpeed = Enemy.MAX_SPEED;
        
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
        self.enemyLabel!.text = "Enemy";
        self.enemyLabel!.fontSize = 25;
        self.enemyLabel!.fontColor = SKColor(red: 236.0 / 255,
            green: 206.0 / 255,
            blue: 118.0 / 255,
            alpha: 1.0);
        self.enemyLabel!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
        self.enemyLabel!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
        self.enemyLabel!.userInteractionEnabled = true;
        self.position = GameTools.RandomPoint(self.World!.frame)
        self.addChild(enemyLabel!);
        
        var moveEnemy = SKAction.followPath(GetRandomPath(self.World!.frame, source: self, target: self.Player!), asOffset: false, orientToPath: true, speed: self.getCircleSpeed() * 13);
        self.runAction(moveEnemy, completion: {self.OnMoveEnemyEnd(self.World!.frame, source: self, target: self.Player!)});
        
        self.JellyAnimation()
    }
    
    func GetRandomPath(frame: CGRect, source: SKShapeNode, target: SKShapeNode) -> CGPath
    {
        
        
        var randomPath: UIBezierPath = UIBezierPath();
        randomPath.moveToPoint(source.position);
        randomPath.addCurveToPoint(target.position, controlPoint1: GameTools.RandomPoint(frame), controlPoint2: GameTools.RandomPoint(frame));
        return randomPath.CGPath;
    }
    
    func GetRandomPath(frame: CGRect, source: SKShapeNode) -> CGPath
    {
        var randomPath: UIBezierPath = UIBezierPath();
        randomPath.moveToPoint(source.position);
        randomPath.addCurveToPoint(GameTools.RandomPointScene(frame), controlPoint1: GameTools.RandomPointScene(frame), controlPoint2: GameTools.RandomPointScene(frame));
        return randomPath.CGPath
    }
    /*
    func RandomPoint(bounds: CGRect)->CGPoint
    {
        /*var mod = Int(arc4random()) % Int(CGRectGetMaxX(bounds));
        var xvalue = Int(bounds.minX) + mod;
        
        mod = Int(arc4random()) % Int(CGRectGetMaxY(bounds));
        var yvalue = Int(bounds.minY) + mod;
        return CGPoint(x: xvalue, y: yvalue);*/
        var mod = Int(arc4random()) % Int(bounds.width);
        var xvalue = Int(bounds.minX) + mod;
        
        mod = Int(arc4random()) % Int(bounds.height);
        var yvalue = Int(bounds.minY) + mod;
        
        return CGPoint(x: xvalue, y: yvalue);
    }*/
    
    func OnMoveEnemyEnd(frame: CGRect, source: SKShapeNode, target: SKShapeNode) -> Void
    {
        var moveEnemy : SKAction;
        var duration : NSTimeInterval = Double(CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs((1 - 8) * Circle.MAX_SIZE_USING_FEED/self.radius) + min(1, 8))
        //println(duration)
        if((self.Player as! PlayerCircle).radius > self.radius)
        {
            if(Playing.Feeds.count != 0)
            {
                moveEnemy = SKAction.followPath( GetRandomPath(self.World!.frame, source: self, target: Playing.Feeds.first! ), asOffset: false, orientToPath: true, speed: self.getCircleSpeed() * 13)
            }
            else
            {
                moveEnemy = SKAction.followPath( GetRandomPath(self.World!.frame, source: self), asOffset: false, orientToPath: true,  speed: self.getCircleSpeed() * 13)
            }
        }
        else
        {
            moveEnemy = SKAction.followPath( GetRandomPath(self.World!.frame, source: self, target: self.Player!), asOffset: false, orientToPath: true, speed: self.getCircleSpeed() * 13)
        }
        self.runAction(moveEnemy, completion: {self.OnMoveEnemyEnd(self.World!.frame, source: self, target: self.Player!)});
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
