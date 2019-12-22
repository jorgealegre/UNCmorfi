//
//  CounterView.swift
//  UNCmorfi
//
//  Created by George Alegre on 29/09/2017.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class CounterView: UIView, CAAnimationDelegate {

    private enum Constants {
        static let lineWidth: CGFloat = 3
        static let arcWidth: CGFloat = 15
        static let arcBackgroundColor: UIColor = .systemOrange
    }

    // MARK: - Layers

    private let circlePathLayer = CAShapeLayer()

    // MARK: - Properties

    private var isIndeterminate = true

    var maxValue = 1500

    var currentValue = 0 {
        didSet {
            currentValue = min(maxValue, currentValue) // Enforce the max value.

            // Wait until stroke animations are done, if they aren't already.
            shouldTransitionFromIndeterminateToDeterminate = true

            // Animate stroke end to reflect progress.
            if !isIndeterminate {
                animateProgressUpdate()
            }
        }
    }

    private var shouldTransitionFromIndeterminateToDeterminate = false

    private let strokeStartAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        return animation
    }()

    private let strokeEndAnimation: CAAnimation  = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        // The model is set to 0, I'm animating towards 1.
        // When this is done, strokeStart is still being animated (catching up with me with 0.5s delay).
        // I don't want this to jump to 0 until strokeStart animation finishes (animationGroup finishes).
        animation.fillMode = .forwards
        return animation
    }()

    private func createStrokeAnimationGroup() -> CAAnimationGroup {
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.5
        strokeAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        strokeAnimationGroup.delegate = self
        strokeAnimationGroup.isRemovedOnCompletion = false
        return strokeAnimationGroup
    }

    private let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi
        animation.duration = 1.5
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        return animation
    }()

    /// Overriding this method to get notified whenever my view controller sets up
    /// constraints on me. This way, we can use AutoLayout from the view controller
    /// and have the path update automatically.
    ///
    /// Maybe we should change strategy since this would cause the path to reset itself
    /// with every layout change.
    override func layoutSubviews() {
        super.layoutSubviews()

        // Setup the main circular layer.
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = min(bounds.width, bounds.height) / 2
        let path = UIBezierPath(arcCenter: center,
                                radius: radius - Constants.arcWidth/2,
                                startAngle: (3/4) * .pi,
                                endAngle: (11/4) * .pi,
                                clockwise: true)

        circlePathLayer.frame = bounds
        circlePathLayer.path = path.cgPath
        // Initially the path will be hidden, except when indeterminate animation is on.
        circlePathLayer.strokeEnd = 0
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        circlePathLayer.lineWidth = Constants.arcWidth
        circlePathLayer.strokeColor = Constants.arcBackgroundColor.cgColor
        circlePathLayer.fillColor = nil

        layer.addSublayer(circlePathLayer)
    }

    func startAnimating() {
        circlePathLayer.add(createStrokeAnimationGroup(), forKey: "strokeAnimationGroup")
        circlePathLayer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        /// This delegate method allows us to stop repeating the indeterminate animation.
        /// At any time, the current value of this view could be set.
        /// If it's set in the middle of an animation, we don't want to stop it completely.
        /// Flag that we should stop animating (i.e. wait for the current animation
        /// but don't keep adding new ones).
        if !shouldTransitionFromIndeterminateToDeterminate {
            // Continue animating until the value is set.
            circlePathLayer.add(rotationAnimation, forKey: "rotationAnimation")
            circlePathLayer.add(createStrokeAnimationGroup(), forKey: "strokeAnimationGroup")
        } else {
            // Prepare the view for the new state (determinate progress with label).
            // We remove any old indeterminate progress animations.
            circlePathLayer.removeAllAnimations()

            // Animate the stroke to indicate the current value.
            animateProgressUpdate()

            // We went from indeterminate to determinate progress.
            isIndeterminate = false // If too many threads access this variable, there might be problems.
        }
    }

    private func animateProgressUpdate() {
        // Add a new animation for the end of the stroke.
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        // Stroke until a 75% of the path to look like a speedometer.
        circlePathLayer.strokeEnd = CGFloat(currentValue)/CGFloat(maxValue) * 0.75
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        circlePathLayer.add(animation, forKey: "strokeEnd")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
}
