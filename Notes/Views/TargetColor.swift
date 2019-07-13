//
//  TargetColor.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class TargetColor: UIView {
    
    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        createCrossLines()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    private func createCrossLines() {
        let startOne = CGPoint(x: 22.0, y: 0.0)
        let endOne = CGPoint(x: 22.0, y: 44.0)
        
        let startTwo = CGPoint(x: 0.0, y: 22.0)
        let endTwo = CGPoint(x: 44.0, y: 22.0)
        
        let pathOne = UIBezierPath()
        pathOne.move(to: startOne)
        pathOne.addLine(to: endOne)
        pathOne.lineWidth = 1.0
        pathOne.stroke()
        
        let pathTwo = UIBezierPath()
        pathTwo.move(to: startTwo)
        pathTwo.addLine(to: endTwo)
        pathTwo.lineWidth = 1.0
        pathTwo.stroke()
        
        self.setNeedsDisplay()
    }
    
    public func createCircle(_ color: UIColor) {
        let path = UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: self.bounds.width - 16.0, height: self.bounds.height - 16.0))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.0
        
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
}
