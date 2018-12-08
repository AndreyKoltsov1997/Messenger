//
//  Sprayer.swift
//  Chat
//
//  Created by Andrey Koltsov on 02/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import UIKit

@objc(Sprayer) class Sprayer: UIApplication {
    
    private var sprayer = TinkoffLogoSprayer()
    
    override func sendEvent(_ event: UIEvent) {
        if event.type != .touches {
            super.sendEvent(event)
            return
        }
        var targetPoint: UITouch?
        var hasTouchReleased = true
        
        if let touches = event.allTouches {
            if let first = touches.first {
                targetPoint = first
            }
            hasTouchReleased = self.isTouchReleased(for: event)
        }
        let shouldSprayStop = (hasTouchReleased && (targetPoint != nil))
        if shouldSprayStop {
            sprayer.stop()
        } else {
            if let point = targetPoint {
                sprayer.start(from: point)
            }
        }
        super.sendEvent(event)
    }
    
    private func isTouchReleased(for event: UIEvent) -> Bool {
        guard let touchPoints = event.allTouches else { return true }
        for touch in touchPoints.enumerated() {
            if touch.element.phase != .cancelled && touch.element.phase != .ended {
                return false
            }
        }
        return true
    }
}
