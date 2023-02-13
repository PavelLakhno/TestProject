//
//  CircleProgressBar.swift
//  QuitSmoke
//
//  Created by user on 13.02.2023.
//

import UIKit

final class CircleProgressBar: UIView {

    public var widthProgress: CGFloat = 10
    public var unfilledColor: UIColor = UIColor.gray
    public var startValue: CGFloat = 0.0
    public var endValue: CGFloat = 0.25
    private var currentValue: CGFloat = 0.0
    public var gradientCollors: [CGColor] = [CGColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1.0),
                                              CGColor(red: 0/255, green: 64/255, blue: 255/255, alpha: 1.0),
                                              CGColor(red: 7/255, green: 3/255, blue: 255/255, alpha: 1.0)
                                              ]
    
    private var backgroundLayer: CAShapeLayer! {
        didSet {
            backgroundLayer.backgroundColor = backgroundColor?.cgColor
            backgroundLayer.strokeColor = unfilledColor.cgColor
            backgroundLayer.fillColor = UIColor.clear.cgColor
            backgroundLayer.lineCap = .round
            backgroundLayer.lineWidth = widthProgress
        }
    }
    
    private var fillLayer: CAShapeLayer! {
        didSet {
            fillLayer.strokeColor = UIColor.systemBlue.cgColor
            fillLayer.fillColor = nil
            fillLayer.lineCap = .round
            fillLayer.lineWidth = widthProgress
            fillLayer.strokeStart = startValue
            fillLayer.strokeEnd = endValue / 100
        }
    }
    
    private var labelLayer: CATextLayer! {
        didSet {
            labelLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            labelLayer.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height / 2.5)
            labelLayer.fontSize = self.bounds.height / 4
            labelLayer.alignmentMode = .center
            labelLayer.foregroundColor = nil
        }
    }
    
    override func draw(_ rect: CGRect) {
        configureBackgroundLayer()
        confugureFillLayer()
        configureLabelLayer()
        configureGradient()
    }
    
    private func configureBackgroundLayer() {
        backgroundLayer = CAShapeLayer()
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let path = UIBezierPath(arcCenter: center,
                                radius: (self.layer.bounds.height - 10) / 2.0,
                                startAngle: (2 * CGFloat.pi) / 3.0,
                                endAngle: CGFloat.pi / 3.0,
                                clockwise: true)
        
        self.layer.masksToBounds = true
        backgroundLayer.path = path.cgPath
        self.layer.addSublayer(backgroundLayer)
    }
    
    private func confugureFillLayer() {
        fillLayer = CAShapeLayer()
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let path = UIBezierPath(arcCenter: center,
                                radius: (self.bounds.height - 10) / 2.0,
                                startAngle: (2 * CGFloat.pi) / 3.0,
                                endAngle: CGFloat.pi / 3.0,
                                clockwise: true)
        
        fillLayer.path = path.cgPath
        self.backgroundLayer.addSublayer(fillLayer)
    }
    
    private func configureLabelLayer() {
        labelLayer = CATextLayer()
        labelLayer.string = "0 %"
        self.layer.addSublayer(labelLayer)
    }
    
    private func configureGradient() {
        let gradient = CAGradientLayer()
        
        gradient.colors = gradientCollors
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.mask = fillLayer
        
        self.backgroundLayer.addSublayer(gradient)
    }
    
    private func animation(val: CGFloat) {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        
        anim.fromValue = currentValue
        anim.toValue = val
        anim.autoreverses = false
        anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        anim.isRemovedOnCompletion = false
        anim.fillMode = .forwards
        
        fillLayer.add(anim, forKey: nil)
    }
    
    public func setValue(value: Double, completion: (() -> Void)? = nil) {
        let value = CGFloat(value)
        let precent = (value/endValue)
        
        animation(val: precent)
        currentValue = precent
        labelLayer.string = "\(Int(precent * 100)) %"
        
        value.isEqual(to: endValue) ? completion?() : nil

    }

}
