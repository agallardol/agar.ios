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
    var moving: Bool = false;
    let radiusMax: CGFloat = 120.0;
    let maxFontSize: CGFloat = 35;
    let enemyQuantity: Int = 3
    let feedQuantity: Int = 50
    var touchPosition: CGPoint? = nil
    var World: SKShapeNode? = nil;
    static var Feeds: [FeedCircle] = [];
    
    var Player: PlayerCircle? = nil;
    static var Enemys: [Enemy] = []
    
    init(width: CGFloat, height: CGFloat) {
        var size = CGSize(width: width, height: height);
        super.init(size: size);
        
        self.backgroundColor = UIColor(red: 232.0 / 255, green: 84.0 / 255, blue: 75.0 / 255, alpha: 1.0);
        
        
        self.anchorPoint = CGPointMake (0.5,0.5);
        
        //Initializing PlayerCircle
        
        size.width *= 2;
        size.height *= 2;
        self.World = SKShapeNode(rectOfSize: size);
        self.World!.name = "world";
        self.World?.position = CGPoint(x: self.frame.midX, y: self.frame.midY);
        self.World?.fillColor = UIColor(red: 70.0 / 255, green: 183.0 / 255, blue: 250.0 / 255, alpha: 1.0);
        self.World?.strokeColor = UIColor(red: 100.0 / 255, green: 150.0 / 255, blue: 20.0 / 255, alpha: 1.0);

        self.addChild(self.World!);

        self.Player = PlayerCircle(world: self.World!);
        self.World!.addChild(self.Player!);
        
        //agregar enemigos
        for i in 1..<enemyQuantity
        {
            var enemy: Enemy = Enemy(world: self.World!, player: self.Player!)
            Playing.Enemys.append(enemy)
            self.World!.addChild(enemy)
        }
        // Initializing FeedCircles

        for i in 1..<feedQuantity
        {
            var feed: FeedCircle = FeedCircle(frame: self.World!.frame);
            Playing.Feeds.append(feed);
            self.World!.addChild(feed);
        
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            // Get the position that was touched (a.k.a. ending point).
            self.touchPosition = touch.locationInNode(self.World);
            var vector : CGPoint = CGPoint(x: self.touchPosition!.x - self.Player!.position.x, y: self.touchPosition!.y - self.Player!.position.y)
            var modulo = sqrt( pow(vector.x,2) + pow(vector.y,2))
            vector.x = vector.x / modulo;
            vector.y = vector.y / modulo;
            self.touchPosition = vector;
            //debugPrintln("WORLD WORLD", self.World!.frame.minX, self.World!.frame.maxX)
            
            //self.Player?.Move(touchPosition)
        }
        self.moving = true;
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.moving = false;
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
        self.touchPosition = touch.locationInNode(self.World);
        var vector : CGPoint = CGPoint(x: self.touchPosition!.x - self.Player!.position.x, y: self.touchPosition!.y - self.Player!.position.y)
        var modulo = sqrt( pow(vector.x,2) + pow(vector.y,2))
        vector.x = vector.x / modulo;
        vector.y = vector.y / modulo;
        self.touchPosition = vector;
        }
        self.moving = true;
        
       
    }

    func didBeginContact(contact: SKPhysicsContact) {
        let firstNode = contact.bodyA.node as! SKShapeNode
        let secondNode = contact.bodyB.node as! SKShapeNode
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        switch (firstBody.categoryBitMask)
        {
            case GameTools.PhysicsCategory.Player:
                switch (secondBody.categoryBitMask)
                {
                    case GameTools.PhysicsCategory.Enemy:
                        //logica choque player con enemy
                        break
                    case GameTools.PhysicsCategory.Feed:
                        (firstBody.node as! PlayerCircle).EatFeed(secondBody.node as! FeedCircle)
                        break
                    
                    default:
                        break
                }
                break
            
            case GameTools.PhysicsCategory.Enemy:
                switch (secondBody.categoryBitMask)
                {
                    case GameTools.PhysicsCategory.Enemy:
                        //logica choque enemy con enemy
                        break
                    case GameTools.PhysicsCategory.Feed:
                        (firstBody.node as! Enemy).EatFeed(secondBody.node as! FeedCircle)
                        break
                
                    default:
                        break
                }
                break
            
            default:
                break
        }
    }
    override func update(currentTime: CFTimeInterval) {
        if (moving)
        {
            debugPrintln("test")
           
            var final : CGPoint = CGPoint(x: self.Player!.position.x + self.Player!.circleSpeed * self.touchPosition!.x, y: self.Player!.position.y + self.Player!.circleSpeed * self.touchPosition!.y)
    
            self.Player!.Move(final)
        }
    }
}