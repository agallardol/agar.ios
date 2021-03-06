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
    let enemyQuantity: Int = 10
    let feedQuantity: Int = 80
    var touchPosition: CGPoint? = nil
    var World: SKShapeNode? = nil;
    static var Feeds: Set<FeedCircle> = []
    static var endGame: Bool = false

    var Player: PlayerCircle? = nil;
    static var Enemys: Set<Enemy> = []
    
    var playButtonLabel = SKLabelNode(fontNamed:"Futura")

    init(width: CGFloat, height: CGFloat) {
        var size = CGSize(width: 2500, height: 3500);
        super.init(size: size);
        Playing.endGame = false
        self.backgroundColor = UIColor(red: 232.0 / 255, green: 84.0 / 255, blue: 75.0 / 255, alpha: 0.0);
        
        self.backgroundColor = UIColor(red: 232.0 / 255, green: 84.0 / 255, blue: 75.0 / 255, alpha: 0.0);
        /*var pe: SKEmitterNode = SKEmitterNode()
        pe.
        pe.particleTexture = SKTexture(imageNamed: "spark.png")
        pe.particleBirthRate = 50
        pe.particleLifetime = 1.0
        pe.particleLifetimeRange = 2.0
        pe.particlePositionRange = CGVector(dx: 1000.0, dy: 1000.0)
        pe.particleRotationRange = 0.39
        pe.particleRotation = 3.548
        pe.particleScale = 0.07
        pe.particleScaleRange = 0.09
        pe.particleAlpha = 0
        pe.particleAlphaRange = 0.2
        pe.particleAlphaSpeed = 29
        pe.particleBlendMode = SKBlendMode.Add
        pe.particleColorBlendFactor = 1*/

        self.anchorPoint = CGPointMake (0.5,0.5);
        
        //Initializing PlayerCircle
        
        size.width *= 2;
        size.height *= 2;
        self.World = SKShapeNode(rectOfSize: size);
        self.World!.name = "world";
        self.World?.position = CGPoint(x: self.frame.midX, y: self.frame.midY);
        self.World?.fillColor = UIColor(red: 0.0 / 255, green: 0.0 / 255, blue: 0.0 / 255, alpha: 1.0);
        self.World?.strokeColor = UIColor(red: 255.0 / 255, green: 255.0 / 255, blue: 255.0 / 255, alpha: 1.0);
        
        let burstPath = NSBundle.mainBundle().pathForResource("Background",
            ofType: "sks")
        
        let burstNode = NSKeyedUnarchiver.unarchiveObjectWithFile(burstPath!)
            as! SKEmitterNode
        self.addChild(burstNode)
        //self.World!.addChild(burstNode)
        self.addChild(self.World!);

        self.Player = PlayerCircle(world: self.World!);
        self.World!.addChild(self.Player!);
        
        
        
        
        playButtonLabel.name = "score";
        
        playButtonLabel.fontSize = 25;
        playButtonLabel.fontColor = SKColor(red: 255.0 / 255,
            green: 255.0 / 255,
            blue: 255.0 / 255,
            alpha: 1.0);
        playButtonLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
        playButtonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
        playButtonLabel.userInteractionEnabled = true;
        playButtonLabel.text = "\(self.Player!.radius)" ;
        playButtonLabel.position.x = 0;
        playButtonLabel.position.y = -25;
        self.Player!.addChild(playButtonLabel);
        
        
        
        //agregar enemigos
        Playing.Enemys = []
        for i in 1..<enemyQuantity
        {
            var enemy: Enemy = Enemy(world: self.World!, player: self.Player!)
            Playing.Enemys.insert(enemy)
            self.World!.addChild(enemy)
        }
        // Initializing FeedCircles
        
        Playing.Feeds = []
        for i in 1..<feedQuantity
        {
            var feed: FeedCircle = FeedCircle(frame: self.World!.frame);
            Playing.Feeds.insert(feed);
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
        debugPrintln("contacto ");
        
        if (contact.bodyA.node == nil)
        {
            debugPrintln("primero nil")
            return;
        
        }
        if (contact.bodyB.node == nil){
            debugPrintln("segundo nil")
            return
        }
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
                        var playerCircle : PlayerCircle = (firstBody.node as! PlayerCircle)
                        var enemyCircle : Enemy = (secondBody.node as! Enemy)
                        
                        if(playerCircle.radius > enemyCircle.radius)
                        {
                            playerCircle.EatEnemy(enemyCircle)
                        }
                        else if(playerCircle.radius < enemyCircle.radius)
                        {
                            if(!Playing.endGame)
                            {
                                Playing.endGame = true
                                enemyCircle.GrowUp(playerCircle.radius / 2)
                                playerCircle.hidden = true
                                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
                                dispatch_after(delayTime, dispatch_get_main_queue()) {
                                    self.gameOver()
                                }
                            }

                        }

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
                        var enemyCircleA: Enemy = (firstBody.node as! Enemy)
                        var enemyCircleB: Enemy = (secondBody.node as! Enemy)
                        
                        if(enemyCircleA.radius > enemyCircleB.radius)
                        {
                            enemyCircleA.EatEnemy(enemyCircleB)
                        }
                        else if(enemyCircleB.radius > enemyCircleA.radius)
                        {
                            enemyCircleB.EatEnemy(enemyCircleA)
                        }
                        break
                    case GameTools.PhysicsCategory.Player:
                        //logica choque player con enemy
                        var enemyCircle : Enemy = (firstBody.node as! Enemy)
                        var playerCircle : PlayerCircle = (secondBody.node as! PlayerCircle)
                        if(playerCircle.radius > enemyCircle.radius)
                        {
                            playerCircle.EatEnemy(enemyCircle)
                        }
                        else if(playerCircle.radius < enemyCircle.radius)
                        {
                            if(!Playing.endGame)
                            {
                                Playing.endGame = true
                                enemyCircle.GrowUp(playerCircle.radius / 2)
                                playerCircle.hidden = true
                                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
                                dispatch_after(delayTime, dispatch_get_main_queue()) {
                                self.gameOver()
                                }
                            }
                        }
                    
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
        if ( Playing.Feeds.count < feedQuantity)
        {
            var feed: FeedCircle = FeedCircle(frame: self.World!.frame);
            Playing.Feeds.insert(feed);
        //    debugPrint(feed.position)
            self.World!.addChild(feed);
            
        }
        
        if ( Playing.Enemys.count < enemyQuantity)
        {
            var enemy: Enemy = Enemy(world: self.World!, player: self.Player!)
            Playing.Enemys.insert(enemy)
            self.World!.addChild(enemy)
            
        }
        
        if (moving)
        {
            if (self.Player!.radius != -50){
                (self.Player!.childNodeWithName("score") as! SKLabelNode).text = "\(self.Player!.radius)";}
            var final : CGPoint = CGPoint(x: self.Player!.position.x +  self.touchPosition!.x, y: self.Player!.position.y + self.touchPosition!.y)
    
            self.Player!.Move(final)
            //debugPrintln(self.Player!.position)
        }
       // debugPrintln(Playing.Feeds.count)
        debugPrintln(Player?.radius)
        
        
        if ((Player!.radius >= 250) && !Playing.endGame)
        {
            Playing.endGame = true
            winGame()
        }
    
    }
    func gameOver(){
        if let scene = MainMenu.unarchiveFromFile("MainMenu") as? MainMenu {
            scene.settt(GameTools.GameState.Lose, points: Int(self.Player!.radius));
            self.view!.presentScene(scene, transition: SKTransition.crossFadeWithDuration(2))
        }
    }
    func winGame(){
        if let scene = MainMenu.unarchiveFromFile("MainMenu") as? MainMenu {
            scene.settt(GameTools.GameState.Win, points: Int(self.Player!.radius));
            self.view!.presentScene(scene, transition: SKTransition.crossFadeWithDuration(2))
        }
    }
}
