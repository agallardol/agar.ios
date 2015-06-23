//
//  Playing.swift
//  AGAR.IOS
//
//  Created by Alfredo Gallardo on 15-06-15.
//  Copyright (c) 2015 Agallardol. All rights reserved.
//

import SpriteKit

class Playing: SKScene, SKPhysicsContactDelegate {
    
    var tempCircle = SKShapeNode(circleOfRadius: 30);
    var currentScale: CGFloat = 1.0;
    let radiusMax: CGFloat = 120.0;
    let maxFontSize: CGFloat = 35;
    let enemyQuantity: Int = 3
    let feedQuantity: Int = 50
    
    var World: SKShapeNode? = nil;
    var Feeds: [FeedCircle] = [];
    
    var Player: PlayerCircle? = nil;
    var Enemys: [Enemy] = []
    
    init(width: CGFloat, height: CGFloat) {
        var size = CGSize(width: width, height: height);
        super.init(size: size);
        
        self.backgroundColor = UIColor(red: 232.0 / 255, green: 84.0 / 255, blue: 75.0 / 255, alpha: 1.0);
        
        
        self.anchorPoint = CGPointMake (0.5,0.5);
        
        //Initializing PlayerCircle
        self.Player = PlayerCircle(frame: self.frame);
        
        size.width *= 2;
        size.height *= 2;
        self.World = SKShapeNode(rectOfSize: size);
        self.World!.name = "world";
        self.World?.position = CGPoint(x: self.frame.midX, y: self.frame.midY);
        self.World?.fillColor = UIColor(red: 70.0 / 255, green: 183.0 / 255, blue: 250.0 / 255, alpha: 1.0);
        self.World?.strokeColor = UIColor(red: 100.0 / 255, green: 150.0 / 255, blue: 20.0 / 255, alpha: 1.0);

        self.addChild(self.World!);

        self.World!.addChild(self.Player!);
        
        //agregar enemigos
        for i in 1..<enemyQuantity
        {
            var enemy: Enemy = Enemy(frame: self.World!.frame)
            self.Enemys.append(enemy)
            self.World!.addChild(enemy)
        }
        // Initializing FeedCircles

        for i in 1..<feedQuantity
        {
            var feed: FeedCircle = FeedCircle(frame: self.World!.frame);
            self.Feeds.append(feed);
            self.World!.addChild(feed);
        
        }
        self.Player?.JellyAnimation();

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0,dy: 0);
        self.physicsWorld.contactDelegate = self;
    }		
    override func didFinishUpdate()
    {
        GameTools.centerOnNode(self.childNodeWithName("world")!.childNodeWithName("player")!);
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            // Get the position that was touched (a.k.a. ending point).
            let touchPosition = touch.locationInNode(self.World)
            
            // Get sprite's current position (a.k.a. starting point).
            let currentPosition = Player!.position
            
            // Calculate the angle using the relative positions of the sprite and touch.
            let angle = atan2(currentPosition.y - touchPosition.y, currentPosition.x - touchPosition.x)
            
            // Define actions for the ship to take.
            let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
            let moveAction = SKAction.moveTo(touchPosition, duration: 0.5)
            
            // Tell the ship to execute actions.
            Player!.runAction(SKAction.sequence([rotateAction, moveAction]))
        }
    }

    func didBeginContact(contact: SKPhysicsContact) {
        let firstNode = contact.bodyA.node as! SKShapeNode
        let secondNode = contact.bodyB.node as! SKShapeNode
        println("Contacto");
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & GameTools.PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & GameTools.PhysicsCategory.Feed != 0)) {
                (firstBody.node as! PlayerCircle).EatFeed(secondBody.node as! FeedCircle)
        }
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}