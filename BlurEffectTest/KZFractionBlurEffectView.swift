//
//  KZFractionBlurEffectView.swift
//  BlurEffectTest
//
//  Created by Konrad Zdunczyk on 11/11/2019.
//  Copyright © 2019 Konrad Zdunczyk (konrad.zdunczyk@gmail.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class KZFractionBlurEffectView: UIView {
    var blurStyle: UIBlurEffect.Style = .extraLight {
        didSet {
            resetAnimator()
        }
    }

    var blurIntensity: CGFloat {
        get {
            return animator.fractionComplete
        }

        set {
            animator.fractionComplete = newValue
        }
    }

    override var backgroundColor: UIColor? {
        set {
            super.backgroundColor = .clear
        }

        get {
            return super.backgroundColor
        }
    }

    private var delta: CGFloat = 0
    private var target: CGFloat = 0
    private var animator: UIViewPropertyAnimator!
    private let maxFrameRate = CGFloat(UIScreen.main.maximumFramesPerSecond)
    private var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink.isPaused = true
        displayLink.add(to: .main, forMode: .common)

        return displayLink
    }()
    private let effectView: UIVisualEffectView = {
        $0.translatesAutoresizingMaskIntoConstraints = false

        return $0
    }(UIVisualEffectView(effect: nil))

    private var isBluringOut: Bool {
        return delta < 0.0
    }

    init(blurStyle: UIBlurEffect.Style = .extraLight) {
        self.blurStyle = blurStyle

        super.init(frame: CGRect())

        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    deinit {
        invalidateAnimator()
        displayLink.invalidate()
    }

    func blurIn(to targetIntensity: CGFloat, duration: TimeInterval = 0.3) {
        target = targetIntensity
        delta = targetIntensity / (maxFrameRate * CGFloat(duration))

        animator.fractionComplete = 0.0

        displayLink.isPaused = false
    }

    func blurOut(duration: TimeInterval = 0.3) {
        target = 0
        delta = -1 * animator.fractionComplete / (maxFrameRate * CGFloat(duration))

        displayLink.isPaused = false
    }

    private func commonInit() {
        setupViews()
        setupConstraints()

        resetAnimator()
    }

    private func setupViews() {
        super.backgroundColor = .clear
        addSubview(effectView)
    }

    private func setupConstraints() {
        let c = [
            effectView.centerXAnchor.constraint(equalTo: centerXAnchor),
            effectView.centerYAnchor.constraint(equalTo: centerYAnchor),
            effectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            effectView.topAnchor.constraint(equalTo: topAnchor)
        ]

        NSLayoutConstraint.activate(c)
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

    private func invalidateAnimator() {
        animator?.stopAnimation(false)
        animator?.finishAnimation(at: UIViewAnimatingPosition.current)
    }

    private func resetAnimator() {
        let fractionComplete: CGFloat = animator?.fractionComplete ?? 0.0

        invalidateAnimator()
        effectView.effect = nil
        animator = UIViewPropertyAnimator(duration: 1.0,
                                          curve: .linear,
                                          animations: { [unowned self] in
                                            self.effectView.effect = UIBlurEffect(style: self.blurStyle)
        })
        animator.pausesOnCompletion = true
        animator.fractionComplete = fractionComplete
    }
}
