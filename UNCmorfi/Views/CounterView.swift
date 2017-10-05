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
    private let circlePathLayer = CAShapeLayer()
    
    private var lineWidth: CGFloat = 3
    private var arcWidth: CGFloat = 15
    private var arcBackgroundColor: UIColor = .orange
    private var arcOutlineColor: UIColor = .red

    var maxValue = 1500
    var currentValue = 0 {
        didSet {
            currentValue = currentValue > maxValue ? maxValue : currentValue // Enforce the max value.

            // Wait until stroke animations are done, if they aren't already.
            shouldStopAnimating = true

            // Animate stroke end to reflect progress.
            if !isAnimating {
                animateProgressUpdate()
            }
        }
    }

    private var shouldStopAnimating = false
    private var isAnimating = true

    private let strokeStartAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        return animation
    }()

    private let strokeEndAnimation: CAAnimation  = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        // The model is set to 0, I'm animating towards 1. When this is done, strokeStart is still being animated.
        // I don't want this to jump to 0 until strokeStart animation finishes (animationGroup finishes).
        animation.fillMode = kCAFillModeForwards
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
        animation.toValue = 2 * Float.pi
        animation.duration = 1.5
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        return animation
    }()

    /*
     Overriding this method to get notified whenever my view controller sets up
     constraints on me. This way, we can use AutoLayout from the view controller
     and have the path update automatically.
     
     Maybe we should change strategy since this would cause the path to reset itself
     with every layout change.
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = min(bounds.width, bounds.height) / 2

        let path = UIBezierPath(arcCenter: center,
                                radius: radius - arcWidth/2,
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
        
        circlePathLayer.lineWidth = arcWidth
        circlePathLayer.strokeColor = arcBackgroundColor.cgColor
        circlePathLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(circlePathLayer)
    }

    private var isInReverse = false
    func startAnimating() {
        circlePathLayer.add(createStrokeAnimationGroup(), forKey: "strokeAnimationGroup")
        circlePathLayer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !shouldStopAnimating {
            // Continue animating until the value is set.
            circlePathLayer.add(createStrokeAnimationGroup(), forKey: "strokeAnimationGroup")
        } else {
            circlePathLayer.removeAllAnimations()
            animateProgressUpdate()
            isAnimating = false // If too many threads access this variable, there might be problems.
        }
    }

    private func animateProgressUpdate() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        // Stroke until a 75% of the path to look like a speedometer.
        circlePathLayer.strokeEnd = CGFloat(currentValue)/CGFloat(maxValue) * 0.75
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
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
