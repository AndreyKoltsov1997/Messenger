//
//  TinkofflogoCollectionprayer.swift
//  Chat
//
//  Created by Andrey Koltsov on 02/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import UIKit

class TinkoffLogoSprayer {
    
    private let spryingIconName = "AppIcon"
    private let SPARAYING_ICON_SIDE_LENGTH = 30

    
    private let POSITION_ANIMATION_KEY = "position"
    private let OPACITY_ANIMATION_KEY = "opacity"
    private let FADING_ANIMATION_KEY = "fading"
    private let INVISIBLE_ANIMATION_KEY = "invisible"
    
    private var logoCollection: [UIImageView]?
    private var isSprayActive = false
    public var sprayingTimer: Timer?
    public var cleanUpTimer: Timer?
    
    
    
    // MARK: - Public
    
    public func start(from touch: UITouch) {
        if logoCollection == nil {
            self.cleanUpLogoCollection()
        }
        self.configureTimers(considerTouch: touch)
    }
    
    public func stop() {
        invalidateTimers()
        cleanUpLogoCollection()
    }
    
    // MARK: - Private
    
    private func getRandomPoint() -> CGPoint {
        return CGPoint(x: Int(arc4random() % 1000), y: Int(arc4random() % 1000))
    }
    
    private func configureTimers(considerTouch touch: UITouch) {
        if sprayingTimer == nil {
            sprayingTimer = self.getSprayingTimer(sprayingFrom: touch)
        }
        
        if cleanUpTimer == nil {
            cleanUpTimer = self.getCollectionCleanerTimer()
        }
    }
    
    private func animateImageOpacityAndPosition(view: UIView) {
        let animationDuration = Double(1.0)
        self.configureMovingAnimation(withIn: view, duration: animationDuration)
        self.configureLogoOpacityAnimation(withIn: view, duration: animationDuration)

    }
    
    private func configureMovingAnimation(withIn view: UIView, duration: Double) {
        let targetPoint = getRandomPoint()
        let logoMovingAnimation = CABasicAnimation(keyPath: self.POSITION_ANIMATION_KEY)
        logoMovingAnimation.fromValue = view.layer.position
        logoMovingAnimation.toValue = targetPoint
        logoMovingAnimation.duration = duration
        view.layer.position = targetPoint
        
        view.layer.add(logoMovingAnimation, forKey: self.FADING_ANIMATION_KEY)
    }
    
    private func configureLogoOpacityAnimation(withIn view: UIView, duration: Double) {
        let logoOpacityAnimation = CABasicAnimation(keyPath: self.OPACITY_ANIMATION_KEY)
        logoOpacityAnimation.fromValue = view.layer.opacity
        logoOpacityAnimation.toValue = 0
        logoOpacityAnimation.duration = duration
        view.layer.opacity = 0
        view.layer.add(logoOpacityAnimation, forKey: self.INVISIBLE_ANIMATION_KEY)
    }
    
    private func getCollectionCleanerTimer() -> Timer {
        let collectionAutomateCleaningInterval = 1.5
        return Timer.scheduledTimer(withTimeInterval: collectionAutomateCleaningInterval, repeats: true, block: { sprayingTimer in
            if self.sprayingTimer == nil {
                return
            }
            self.cleanUpLogoCollection()
        })
    }
    
    private func getSprayingTimer(sprayingFrom touch: UITouch) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            guard let originView = touch.view else {
                let misleadingMsg = "Unable to get view instance."
                print(misleadingMsg)
                return
            }
            
            guard let window = originView.window else {
                let misleadingMsg = "Unable to get window instance."
                print(misleadingMsg)
                return
            }
            guard let targetView = window.subviews.first else { return }
            let logo = self.getSprayingLogo(from: touch.location(in: targetView))
            self.logoCollection?.append(logo)
            targetView.addSubview(logo)
            self.animateImageOpacityAndPosition(view: logo)
        })
    }
    
    private func getSprayingLogo(from location: CGPoint) -> UIImageView {
        let SPRAYING_ICON_SIDE_SIZE = CGSize(width: SPARAYING_ICON_SIDE_LENGTH, height: SPARAYING_ICON_SIDE_LENGTH)
        let logo = UIImageView(frame: CGRect(origin: location, size: SPRAYING_ICON_SIDE_SIZE))
        logo.image = UIImage(named: self.spryingIconName)
        return logo
    }
    
    private func invalidateTimers() {
        self.sprayingTimer = nil
        self.cleanUpTimer = nil
    }
    
    private func cleanUpLogoCollection() {
        let cleanUpTimeOffset = 2.0
        let emptyCollection = [UIImageView]()
        for logo in logoCollection ?? emptyCollection {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + cleanUpTimeOffset, execute:  {
                logo.removeFromSuperview()
            })
        }
    }
}
