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
    var World: SKShapeNode? = nil;
    var playerLabel: SKLabelNode? = nil;
    
    convenience init(world: SKShapeNode)
    {
        self.init(radius: PlayerCircle.DEFAULT_SIZE, world: world, fillColor: PlayerCircle.DEFAULT_FILL_COLOR, strokeColor: PlayerCircle.DEFAULT_STROKE_COLOR);
    }

    convenience init(world: SKShapeNode, fillColor: UIColor, strokeColor: UIColor)
    {
        self.init(radius: PlayerCircle.DEFAULT_SIZE, world: world, fillColor: fillColor, strokeColor: strokeColor);
    }
    
    init(radius: CGFloat, world: SKShapeNode, fillColor: UIColor, strokeColor: UIColor)
    {
               self.World = world
        super.init(radius: radius, position: GameTools.RandomPoint(world.frame))

        //self.circleSpeed = PlayerCircle.MAX_SPEED;

        //Color
        //self.strokeColor = strokeColor;
        //self.fillColor = fillColor;
        self.addChild(SKSpriteNode(imageNamed: "sunDot@2x0.png"))
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
            blue: 218.0 / 255,
            alpha: 1.0);
        self.playerLabel!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
        self.playerLabel!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
        self.playerLabel!.userInteractionEnabled = true;
        
        self.addChild(playerLabel!);
        self.JellyAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func Move(touchPosition: CGPoint)->Void {
        
            // Get sprite's current position (a.k.a. starting point).
        
        let currentPosition = self.position
        
        var xVect = touchPosition.x - currentPosition.x
        var yVect = touchPosition.y - currentPosition.y
        let norm = sqrt(pow(xVect, 2) + pow(yVect, 2)   )
        
        var normalizedVector: CGVector = CGVectorMake(xVect / norm,  yVect / norm)
        
        var dx = normalizedVector.dx*self.getCircleSpeed()
        var dy = normalizedVector.dy*self.getCircleSpeed()
        
        var newPosition:CGPoint = CGPoint(x: currentPosition.x + dx, y: currentPosition.y + dy)
        
        //debugPrintln(self.World!.position)
        
       // debugPrintln(newPosition)
        
        if ((newPosition.x < -self.World!.frame.width / 2 && dx < 0) || (newPosition.x > self.World!.frame.width / 2  && dx > 0))
        {
            dx = 0;
        }
        if ((newPosition.y < -self.World!.frame.height / 2  && dy < 0) || (newPosition.y > self.World!.frame.height / 2  && dy > 0))
        {
            dy = 0;
        }
        
        //var directionX: CGFloat = x / abs(x)
        //var directionY: CGFloat = y / abs(y)
        // Calculate the angle using the relative positions of the sprite and touch.
        let angle = atan2(currentPosition.y - touchPosition.y, currentPosition.x - touchPosition.x)
            
        // Define actions for the ship to take.
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
        let moveAction =   SKAction.moveByX(dx, y: dy, duration: 0.0)


        // Tell the ship to execute actions.
        self.runAction(SKAction.sequence([rotateAction, moveAction]))
    }
}