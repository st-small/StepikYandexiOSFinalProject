//
//  GalleryCell.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/13/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class GalleryCell: UICollectionViewCell {

    static let reuseId = "GalleryCell"
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        addSubview(mainImageView)
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(5.0)
            make.bottom.equalToSuperview().offset(-5.0)
            make.left.equalToSuperview().offset(5.0)
            make.right.equalToSuperview().offset(-5.0)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 5.0
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        
        clipsToBounds = false
    }
    
    public func update(_ image: UIImage) {
        mainImageView.image = image
        setNeedsDisplay()
    }
}
