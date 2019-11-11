//
//  KZFractionBlurEffectView.swift
//  BlurEffectTest
//
//  Created by Konrad Zdunczyk on 11/11/2019.
//  Copyright © 2019 Konrad Zdunczyk. All rights reserved.
//

import UIKit

class KZFractionBlurEffectView: UIVisualEffectView {
    let animationCurve: UIView.AnimationCurve
    var fractionComplete: CGFloat {
        get {
            return animator.fractionComplete
        }

        set {
            animator.fractionComplete = newValue
        }
    }

    private var animator: UIViewPropertyAnimator!
    private var delta: CGFloat = 0
    private var target: CGFloat = 0
    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink.isPaused = true
        displayLink.add(to: .main, forMode: .common)

        return displayLink
    }()
    private let frameRate = CGFloat(UIScreen.main.maximumFramesPerSecond)

    private var isBluringOut: Bool {
        return delta < 0.0
    }

    init(blurStyle: UIBlurEffect.Style, animationCurve: UIView.AnimationCurve = .linear) {
        self.animationCurve = animationCurve

        super.init(effect: nil)

        animator = UIViewPropertyAnimator(duration: 1.0,
                                          curve: animationCurve,
                                          animations: { [unowned self] in
                                            self.effect = UIBlurEffect(style: blurStyle)
        })
    }

    override init(effect: UIVisualEffect?) {
        fatalError("init(effect:) has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        animator.stopAnimation(false)
        animator.finishAnimation(at: UIViewAnimatingPosition.current)
    }

    func blurIn(to target: CGFloat, duration: TimeInterval = 0.3) {
        self.target = target
        self.delta = target / (frameRate * CGFloat(duration))

        animator.fractionComplete = 0.0

        displayLink.isPaused = false
    }

   func blurOut(duration: TimeInterval = 0.3) {
       target = 0
       delta = -1 * animator.fractionComplete / (frameRate * CGFloat(duration))

       displayLink.isPaused = false
   }

    @objc private func tick() {
        animator.fractionComplete += delta

        if isBluringOut {
            if animator.fractionComplete <= target || animator.fractionComplete <= 0.0 {
                displayLink.isPaused = true
            }
        } else {
            if animator.fractionComplete >= target || animator.fractionComplete >= 1.0 {
                displayLink.isPaused = true
            }
        }


    }
}
