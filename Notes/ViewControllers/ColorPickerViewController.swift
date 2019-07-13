//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public protocol ColorPickerDelegate: class {
    func didSelectColor(_ colorPoint: ColorPoint?)
}

public class ColorPickerViewController: UIViewController {
    
    // UI elements
    @IBOutlet private weak var colorPreviewContainer: UIView!
    @IBOutlet private weak var colorHexValue: UILabel!
    @IBOutlet private weak var brightnessSlider: UISlider!
    @IBOutlet private weak var colorPickerField: ColorPickerField!
    
    private var targetColor: TargetColor!
    
    // Data
    private var selectedPoint: CGPoint?
    private var selectedColor: UIColor?
    private var brightness: Float = 1.0
    
    public weak var delegate: ColorPickerDelegate?

    init(_ colorPoint: ColorPoint? = nil, delegate: ColorPickerDelegate) {
        super.init(nibName: "ColorPickerViewController", bundle: nil)
        selectedColor = colorPoint?.color
        selectedPoint = colorPoint?.point
        brightness = colorPoint?.brightness ?? 1.0
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func loadView() {
        super.loadView()
        
        configureColorContainer()
        configureHexValue()
        configureBrightnessSlider()
        configureColorPickerField()
        configureTargetColor()
    }
    
    private func configureColorContainer() {
        colorPreviewContainer.layer.borderWidth = 1.0
        colorPreviewContainer.layer.borderColor = UIColor.black.cgColor
        colorPreviewContainer.layer.cornerRadius = 5.0
        colorPreviewContainer.backgroundColor = selectedColor ?? .white
    }
    
    private func configureHexValue() {
        colorHexValue.text = "#000000"
        guard let color = selectedColor else { return }
        colorHexValue.text = color.toHexString()
    }
    
    private func configureBrightnessSlider() {
        brightnessSlider.value = brightness
        brightnessSlider.addTarget(self, action: #selector(brightnessChanged(_:)), for: .valueChanged)
    }
    
    @objc private func brightnessChanged(_ sender: UISlider) {
        brightness = sender.value
        updateUI()
    }
    
    private func configureColorPickerField() {
        view.getGradient(colorPickerField.frame)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        colorPickerField.isUserInteractionEnabled = true
        colorPickerField.addGestureRecognizer(tap)
    }
    
    @objc private func tapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: colorPickerField)
        targetColor.center = CGPoint(x: location.x, y: location.y)
        selectedPoint = location
        updateUI()
    }
    
    private func configureTargetColor() {
        let point = selectedPoint ?? CGPoint(x: 0, y: colorPickerField.bounds.maxY)
        targetColor = TargetColor(frame: CGRect(x: point.x - 22.0, y: point.y - 22.0, width: 44.0, height: 44.0))
        colorPickerField.addSubview(targetColor)
        targetColor.createCircle(selectedColor ?? .white)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        targetColor.isUserInteractionEnabled = true
        targetColor.addGestureRecognizer(panGesture)
    }
    
    @objc private func draggedView(_ sender: UIPanGestureRecognizer) {
        self.colorPickerField.bringSubviewToFront(targetColor)
        let translation = sender.translation(in: self.colorPickerField)
        var x: CGFloat = 0
        var y: CGFloat = 0
        if translation.x > 0 {
            x = min(targetColor.center.x + translation.x, colorPickerField.bounds.maxX)
        } else {
            x = max(0, targetColor.center.x + translation.x)
        }
        
        if translation.y > 0 {
            y = min(targetColor.center.y + translation.y, colorPickerField.bounds.maxY)
        } else {
            y = max(0, targetColor.center.y + translation.y)
        }
        
        targetColor.center = CGPoint(x: x, y: y)
        sender.setTranslation(CGPoint.zero, in: self.colorPickerField)
        selectedPoint = targetColor.center
        updateUI()
    }
    
    private func getColorAtPoint(point: CGPoint) -> UIColor {
        let rectangle = colorPickerField.bounds
        let elementSize: CGFloat = 1.0
        let saturationExponentTop: Float = 0
        let saturationExponentBottom: Float = 1
        var roundedPoint = CGPoint(x: elementSize * CGFloat(Int(point.x / elementSize)), y: elementSize * CGFloat(Int(point.y / elementSize)))
        let hue = roundedPoint.x / rectangle.width
        
        roundedPoint.y -= rectangle.origin.y
        
        var saturation = roundedPoint.y < rectangle.height / 2.0 ? CGFloat(2 * roundedPoint.y) / rectangle.height
            : 2.0 * CGFloat(rectangle.height - roundedPoint.y) / rectangle.height
        
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < rectangle.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        
        return UIColor(hue: hue, saturation: saturation, brightness: CGFloat(brightness), alpha: 1.0)
    }
    
    private func updateUI() {
        guard let point = selectedPoint else { return }
        selectedColor = getColorAtPoint(point: point)
        colorPreviewContainer.backgroundColor = selectedColor
        targetColor.createCircle(selectedColor ?? .black)
        colorHexValue.text = selectedColor?.toHexString()
    }
    
    @IBAction private func dismiss(_ sender: UIButton) {
        let colorPoint = ColorPoint(color: selectedColor, brightness: brightness, point: selectedPoint)
        delegate?.didSelectColor(colorPoint)
        navigationController?.popViewController(animated: true)
    }
}
