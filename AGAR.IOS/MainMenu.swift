//
//  GameScene.swift
//  AGAR.IOS
//
//  Created by Alfredo Gallardo on 14-06-15.
//  Copyright (c) 2015 Agallardol. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    var tempCircle = SKShapeNode(circleOfRadius: 30);
    var currentScale: CGFloat = 1.0;
    let radiusMax: CGFloat = 120.0;
    let maxFontSize: CGFloat = 35;
    
    var background = SKSpriteNode(imageNamed: "background.png");
    var playButton = SKShapeNode(circleOfRadius: 60);
    var myLabel = SKLabelNode(fontNamed:"Futura")
    var playButtonLabel = SKLabelNode(fontNamed:"Futura")
    var isEndGame: Bool = false;
    var points: Int = 0;
    func settt(isEndGame: Bool, points: Int)
    {
        //self.init()
        self.isEndGame = true
        self.points = points
    }
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        /*myLabel.text = "AGAR.IOS";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:(CGRectGetMaxX(self.frame) - CGRectGetMidX(self.frame)/2), y:CGRectGetMidY(self.frame));
        myLabel.fontColor = SKColor(red: 236.0 / 255,
            green: 206.0 / 255,
            blue: 118.0 / 255,
            alpha: 1.0);
        myLabel.zPosition = 2;
        myLabel.name = "titleLabel";
        self.addChild(myLabel);*/
        
        
        //Set Background Image
       /* background.anchorPoint = CGPoint(x: 0, y: 0);
        background.size = self.size;
        background.zPosition = -2;
        self.addChild(background);*/
        
        playButton.name = "playButtonShape";
        playButton.setScale(currentScale);
        playButton.strokeColor = SKColor(red: 0 / 255,
            green: 0 / 255,
            blue: 0 / 255,
            alpha: 1.0);
        
        /*playButton.fillColor = UIColor(red: 86.0 / 255,
            green: 38.0 / 255,
            blue: 55.0 / 255,
            alpha: 0.9);*/
        let spritePlayer: SKSpriteNode = SKSpriteNode(imageNamed: "sunDot@2x.png")
        spritePlayer.name = "playButtonSprite"
        playButton.addChild(spritePlayer)
        playButton.zPosition = 1
        playButton.position = CGPoint(x:(CGRectGetMaxX(self.frame) - CGRectGetMidX(self.frame)/2), y:CGRectGetMidY(self.frame) - self.frame.height/4);
        playButton.antialiased = true;
        
        playButtonLabel.name = "playButtonLabel";

        playButtonLabel.fontSize = 25;
        playButtonLabel.fontColor = SKColor(red: 236.0 / 255,
            green: 206.0 / 255,
            blue: 118.0 / 255,
            alpha: 1.0);
        playButtonLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
        playButtonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
        playButtonLabel.userInteractionEnabled = true;
        playButton.addChild(playButtonLabel);
        self.addChild(playButton);
        playButton.userInteractionEnabled = false;
        
        //Enemy
        tempCircle.position = RandomPoint(self.frame);
        tempCircle.zPosition = 0;
        tempCircle.strokeColor = SKColor(red: 236.0 / 255,
            green: 206.0 / 255,
            blue: 118.0 / 255,
            alpha: 1.0);
        /*tempCircle.fillColor = SKColor(red: 86.0 / 255,
            green: 38.0 / 255,
            blue: 55.0 / 255,
            alpha: 0.9);*/
        
        tempCircle.addChild(SKSpriteNode(imageNamed: "redDot@2x.png"))
        tempCircle.antialiased = true;
        self.addChild(tempCircle);
        
        if(self.isEndGame)
        {
            
            (self.childNodeWithName("loseLabel") as! SKLabelNode).hidden = false;
            (self.childNodeWithName("pointsLabel") as! SKLabelNode).hidden = false;
            (self.childNodeWithName("pointsNumberLabel") as! SKLabelNode).hidden = false;
            (self.childNodeWithName("pointsNumberLabel") as! SKLabelNode).text = String(self.points)
            playButtonLabel.text = "ReJugar";
        }
        else {
            (self.childNodeWithName("loseLabel") as! SKLabelNode).hidden = true;
            (self.childNodeWithName("pointsLabel") as! SKLabelNode).hidden = true;
            (self.childNodeWithName("pointsNumberLabel") as! SKLabelNode).hidden = true;
            playButtonLabel.text = "Jugar";
        }
        
        
        var movePlayButton = SKAction.followPath( GetRandomPath(self.frame, button: playButton, circle: tempCircle), asOffset: false, orientToPath: true, duration: 8.0);
        
        playButton.runAction(movePlayButton, completion: {self.OnMovePlayButtonEnd(self.frame, button: self.playButton, circle: self.tempCircle);});
    }
    

    func GetRandomPath(frame: CGRect, button: SKShapeNode, circle: SKShapeNode) -> CGPath
    {
        var randomPath: UIBezierPath = UIBezierPath();
        randomPath.moveToPoint(button.position);
        randomPath.addCurveToPoint(circle.position, controlPoint1: RandomPoint(frame), controlPoint2: RandomPoint(frame));
        return randomPath.CGPath;
    }
    func OnMovePlayButtonEnd(frame: CGRect, button: SKShapeNode, circle: SKShapeNode) -> Void
    {
        //println(button.frame.width / 2);
        //var label = button.childNodeWithName("playButtonLabel") as! SKLabelNode;
        if ((button.frame.width / 2) < self.radiusMax)
        {
            println("Agrandando");
            self.currentScale += 0.05;
            button.setScale(currentScale);
            //label.fontSize += 4;
        }
        tempCircle.position = RandomPoint(self.frame);
        var movePlayButton = SKAction.followPath( GetRandomPath(self.frame, button:button, circle: circle), asOffset: false, orientToPath: true, duration: 4.0);
        button.runAction(movePlayButton, completion: {self.OnMovePlayButtonEnd(frame, button: button, circle: self.tempCircle) });
    }
    func RandomPoint(bounds: CGRect)->CGPoint
    {
        var mod = Int(arc4random()) % Int(CGRectGetMaxX(bounds));
        var xvalue = Int(bounds.minX) + mod;
        
        mod = Int(arc4random()) % Int(CGRectGetMaxY(bounds));
        var yvalue = Int(bounds.minY) + mod;
        return CGPoint(x: xvalue, y: yvalue);
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            var node = self.nodeAtPoint(location);
            //println(node.name);
            if(node.name == "playButtonSprite")
            {
                println("Play Touch");
                let scene = Playing(width: 1000, height: 1000);
                var skView = self.view as SKView!
                scene.scaleMode = SKSceneScaleMode.AspectFill;
                skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(2));
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
