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
    var currentValue = 0

    private var isAnimating = false
    private let inAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        return animation
    }()

    private let outAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        return animation
    }()

    private let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform")
        let transform = CATransform3DMakeRotation(2 * .pi, 0, 0, 1)
        animation.toValue = transform
        animation.duration = 1.5
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
        
//        let startAngle: CGFloat = (3/4) * .pi
//        let endAngle: CGFloat = (1/4) * .pi
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius - arcWidth/2,
                                startAngle: (3/4) * .pi,
                                endAngle: (11/4) * .pi,
                                clockwise: true)

        circlePathLayer.frame = bounds
        circlePathLayer.path = path.cgPath
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        circlePathLayer.lineWidth = arcWidth
        circlePathLayer.strokeColor = arcBackgroundColor.cgColor
        circlePathLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(circlePathLayer)
    }
    
    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "transform")
        let transform = CATransform3DMakeRotation(2 * .pi, 0, 0, 1)
        animation.fromValue = circlePathLayer.transform
        animation.toValue = transform
        animation.duration = 1.5

        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = inAnimation.duration + outAnimation.beginTime
        strokeAnimationGroup.isRemovedOnCompletion = false
        strokeAnimationGroup.repeatCount = .infinity
        strokeAnimationGroup.animations = [inAnimation, outAnimation, animation]

        circlePathLayer.add(strokeAnimationGroup, forKey: "strokeAnimation")
//        circlePathLayer.add(rotationAnimation, forKey: "rotationAnimation")
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
