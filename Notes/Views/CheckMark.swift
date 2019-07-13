//
//  CheckMark.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class CheckMark: UIView {
    
    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        createCircle()
        createMark()
    }
    
    private func createCircle() {
        path = UIBezierPath(ovalIn: CGRect(x: 2.5, y: 2.5, width: self.bounds.width - 5.0, height: self.bounds.height - 5.0))
        UIColor.clear.setFill()
        path.fill()
        path.lineWidth = 1.0
        path.stroke()
    }
    
    private func createMark() {
        let start = CGPoint(x: 23.0, y: 5.5)
        let medium = CGPoint(x: 15.0, y: 26.0)
        let end = CGPoint(x: 5.0, y: 17.0)
        
        //design the path
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: medium)
        path.addLine(to: end)
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.0
        
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
}
