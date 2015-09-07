//
//  EndGameOverlay.swift
//  AGAR.IOS
//
//  Created by Mac 3 on 07-09-15.
//  Copyright (c) 2015 Agallardol. All rights reserved.
//
import SpriteKit
public class EndGameOverlay{
    
    var overlayView = SKView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: EndGameOverlay {
        struct Static {
            static let instance: EndGameOverlay = EndGameOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: SKView) {
        
        overlayView.frame = CGRectMake(0, 0, 80, 80)
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor(white: 0x444444, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}