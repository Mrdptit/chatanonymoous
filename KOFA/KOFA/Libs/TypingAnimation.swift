//
//  TypingAnimation.swift
//  KOFA
//
//  Created by may10 on 11/23/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import Foundation
import UIKit

struct TypingAnimationAppearance {
    
    var dotSize: CGFloat!
    var dotSpacing: CGFloat!
    var dotColor: UIColor!
    var dotCount: Int!
    var jumpHeight: CGFloat!
    var jumpDuration: TimeInterval!
    
    init () {
        dotSize = 6
        dotSpacing = 4
        dotColor = UIColor.gray
        dotCount = 3
        jumpHeight = 10
        jumpDuration = 0.35
    }
}

class TypingAnimation: UIView {
    
    // MARK: Properties
    
    var appearance: TypingAnimationAppearance = TypingAnimationAppearance()
    var dots: [UIView] = []
    
    
    // MARK: Init
    
    init () {
        super.init(frame: CGRect(x: 0, y: 0, width: (CGFloat(appearance.dotCount) * appearance.dotSize) + (CGFloat(appearance.dotCount) * appearance.dotSpacing), height: appearance.dotSize + appearance.jumpHeight))
        
        var currentX: CGFloat = 0
        for _ in 0..<appearance.dotCount {
            let dot = drawDot()
            addSubview(dot)
            dots.append(dot)
            dot.frame.origin.x = currentX
            currentX += appearance.dotSize + appearance.dotSpacing
        }
        
        startAnimating()
    }
    
    required init (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    // MARK: Dot
    
    func drawDot () -> UIView {
        
        let dot = UIView (frame: CGRect(x: 0, y: 0, width: appearance.dotSize, height: appearance.dotSize))
        dot.backgroundColor = appearance.dotColor
        dot.layer.cornerRadius = appearance.dotSize/2
        
        return dot
    }
    
    
    // MARK: Animation
    
    var jumpAnim: CABasicAnimation {
        get {
            let anim = CABasicAnimation(keyPath: "position.y")
            anim.fromValue = appearance.dotSize/2
            anim.toValue = appearance.jumpHeight
            anim.duration = appearance.jumpDuration
            anim.repeatCount = Float.infinity
            anim.autoreverses = true
            
            return anim
        }
    }
    
    func startAnimating () {
        
        var del: TimeInterval = 0
        
        for dot in dots {
            let when = DispatchTime.now() + del
            DispatchQueue.main.asyncAfter(deadline: when) {
                dot.layer.add(self.jumpAnim, forKey: "jump")
            }
            
            del += appearance.jumpDuration / TimeInterval(appearance.jumpHeight) * TimeInterval(appearance.dotCount) * 2
        }
    }
    
}
