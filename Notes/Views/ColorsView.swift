//
//  ColorsView.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/3/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit
import SnapKit

public protocol ColorsViewDelegate: class {
    func selectedColor(_ color: UIColor)
    func openColorPickerTapped()
}

public class ColorsView: UIView {
    
    // UI elements
    private var whiteView: UIView!
    private var redView: UIView!
    private var greenView: UIView!
    private var customColorView: UIView!
    
    // Data
    public weak var delegate: ColorsViewDelegate?
    private var selectedView: UIView?
    private var viewsSpacing: CGFloat {
        let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let screenWithoutMargins = width - 32.0
        return (screenWithoutMargins - 240.0)/3
    }
    private var isNeedGradient = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        setupWhiteView()
        setupRedView()
        setupGreenView()
        setupCustomColorView()
    }
    
    private func setupWhiteView() {
        whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.borderWidth = 1.0
        whiteView.layer.borderColor = UIColor.black.cgColor
        self.addSubview(whiteView)
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.snp.remakeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.height.equalTo(60.0)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(whiteViewTapped(_:)))
        whiteView.addGestureRecognizer(tap)
        
        let mark = setupCheckMark()
        whiteView.addSubview(mark)
    }
    
    private func setupRedView() {
        redView = UIView()
        redView.backgroundColor = .red
        redView.layer.borderWidth = 1.0
        redView.layer.borderColor = UIColor.black.cgColor
        self.addSubview(redView)
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.snp.remakeConstraints { make in
            make.left.equalTo(whiteView.snp.right).offset(viewsSpacing)
            make.bottom.top.equalToSuperview()
            make.width.height.equalTo(60.0)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(redViewTapped(_:)))
        redView.addGestureRecognizer(tap)
    }
    
    private func setupGreenView() {
        greenView = UIView()
        greenView.backgroundColor = .green
        greenView.layer.borderWidth = 1.0
        greenView.layer.borderColor = UIColor.black.cgColor
        self.addSubview(greenView)
        greenView.translatesAutoresizingMaskIntoConstraints = false
        greenView.snp.remakeConstraints { make in
            make.left.equalTo(redView.snp.right).offset(viewsSpacing)
            make.bottom.top.equalToSuperview()
            make.width.height.equalTo(60.0)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(greenViewTapped(_:)))
        greenView.addGestureRecognizer(tap)
    }
    
    private func setupCustomColorView() {
        customColorView = UIView()
        customColorView.backgroundColor = .clear
        customColorView.layer.borderWidth = 1.0
        customColorView.layer.borderColor = UIColor.black.cgColor
        self.addSubview(customColorView)
        customColorView.translatesAutoresizingMaskIntoConstraints = false
        customColorView.snp.remakeConstraints { make in
            make.left.equalTo(greenView.snp.right).offset(viewsSpacing)
            make.bottom.top.equalToSuperview()
            make.width.height.equalTo(60.0)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(customColorViewTapped(_:)))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(openColorPicker(_:)))
        customColorView.addGestureRecognizer(tap)
        customColorView.addGestureRecognizer(longPress)
    }
    
    public func updateCustomColorView(_ color: UIColor) {
        cleanViews()
        let mark = setupCheckMark()
        
        switch color {
        case .white:
            whiteView.addSubview(mark)
            whiteView.backgroundColor = color
        case .red:
            redView.addSubview(mark)
            redView.backgroundColor = color
        case .green:
            greenView.addSubview(mark)
            greenView.backgroundColor = color
        default:
            customColorView.addSubview(mark)
            customColorView.backgroundColor = color
            isNeedGradient = false
        }
        setNeedsDisplay()
    }
    
    @objc private func whiteViewTapped(_ sender: UITapGestureRecognizer) {
        cleanViews()
        let mark = setupCheckMark()
        whiteView.addSubview(mark)
        delegate?.selectedColor(.white)
    }
    
    @objc private func redViewTapped(_ sender: UITapGestureRecognizer) {
        cleanViews()
        let mark = setupCheckMark()
        redView.addSubview(mark)
        delegate?.selectedColor(.red)
    }
    
    @objc private func greenViewTapped(_ sender: UITapGestureRecognizer) {
        cleanViews()
        let mark = setupCheckMark()
        greenView.addSubview(mark)
        delegate?.selectedColor(.green)
    }
    
    @objc private func customColorViewTapped(_ sender: UITapGestureRecognizer) {
        cleanViews()
        let mark = setupCheckMark()
        customColorView.addSubview(mark)
    }
    
    @objc private func openColorPicker(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            delegate?.openColorPickerTapped()
        }
    }
    
    private func cleanViews() {
        [whiteView, redView, greenView, customColorView].forEach({ $0?.subviews.forEach({ $0.removeFromSuperview() }) })
    }
    
    private func setupCheckMark() -> UIView {
        return CheckMark(frame: CGRect(x: 30, y: 0, width: 30.0, height: 30.0))
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        if isNeedGradient {
            getGradient(customColorView.frame)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
}

public extension UIView {
    func getGradient(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let rectangle = CGRect(x: rect.origin.x, y: rect.origin.y,
                               width: rect.width, height: rect.height)
        let elementSize: CGFloat = 1.0
        let saturationExponentTop: Float = 0
        let saturationExponentBottom: Float = 1
        
        // main palette
        for y in stride(from: CGFloat(0), to: rectangle.height, by: elementSize) {
            
            var saturation = y < rectangle.height / 2.0 ? CGFloat(2 * y) / rectangle.height : 2.0 * CGFloat(rectangle.height - y) / rectangle.height
            saturation = CGFloat(powf(Float(saturation), y < rectangle.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rectangle.height / 2.0 ? CGFloat(1.0) : 1.0
            
            for x in stride(from: (0 as CGFloat), to: rectangle.width, by: elementSize) {
                let hue = x / rectangle.width
                
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                
                guard let context = context else { return }
                context.setFillColor(color.cgColor)
                context.fill(CGRect(x: x + rectangle.origin.x, y: y + rectangle.origin.y, width: elementSize, height: elementSize))
            }
        }
    }
    
    func getPointForColor(color: UIColor) -> CGPoint {
        var hue:CGFloat=0
        var saturation:CGFloat=0
        var brightness:CGFloat=0
        
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        
        var yPos: CGFloat = 0
        let halfHeight = (self.bounds.height / 2)
        
        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0/2)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            //use brightness to get Y
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }
        
        let xPos = hue * self.bounds.width
        
        return CGPoint(x: xPos, y: yPos)
    }
}
