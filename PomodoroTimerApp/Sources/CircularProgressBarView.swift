//
//  CircularProgressBarView.swift
//  PomodoroTimerApp
//
//  Created by Nick Spravtsev on 24.08.2022.
//

import UIKit

class CircularProgressBarView: UIView {

    // MARK: - Properties

    private var progressLayer = CAShapeLayer()
    private var circleLayer = CAShapeLayer()
    private var startPoint = CGFloat()
    private var endPoint = CGFloat()

    // Path for animation
    private var circularPath = UIBezierPath()

    // MARK: - Outlets

    lazy var imageView: UIView = {
        let image = UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
        let imageView = UIImageView(image: image)

        return imageView
    }()

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Methods

    func createCircularPath(color: UIColor, clockwise: Bool) {

        if clockwise {
            startPoint = CGFloat(-Double.pi / 2)
            endPoint = CGFloat(3 * Double.pi / 2)
        } else {
            startPoint = CGFloat(3 * Double.pi / 2)
            endPoint = CGFloat(-Double.pi / 2)
        }

        circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                                    radius: 150,
                                    startAngle: startPoint,
                                    endAngle: endPoint, clockwise: clockwise)
        // Static circle
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 3.0
        circleLayer.strokeEnd = 1
        circleLayer.strokeColor = UIColor.white.cgColor
        layer.addSublayer(circleLayer)

        // Progress bar circle
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = color.cgColor
        layer.addSublayer(progressLayer)

        // Figure on progress bar
        addSubview(imageView)
    }

    func progressAnimation(duration: TimeInterval, autostart: Bool) {
        // Animation for progress bar
        let circulatProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circulatProgressAnimation.duration = duration
        circulatProgressAnimation.toValue = 1.0
        circulatProgressAnimation.fillMode = .forwards
        circulatProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circulatProgressAnimation, forKey: "progressAnim")

        // Animation for figure on progress bar
        let orbitAnimation = CAKeyframeAnimation(keyPath: "position")
        orbitAnimation.path = circularPath.cgPath
        orbitAnimation.duration = duration + 0.05
        orbitAnimation.isAdditive = false
        orbitAnimation.repeatCount = 1
        orbitAnimation.calculationMode = .paced
        orbitAnimation.rotationMode = .rotateAutoReverse
        imageView.layer.add(orbitAnimation, forKey: "orbit")

        if !autostart {
            pauseAnimation()
        }
    }

    func pauseAnimation() {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    func resumeAnimation() {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}
