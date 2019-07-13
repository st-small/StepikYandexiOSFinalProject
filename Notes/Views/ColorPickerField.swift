//
//  ColorPickerField.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class ColorPickerField: UIView {
    
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
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        getGradient(rect)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
}
