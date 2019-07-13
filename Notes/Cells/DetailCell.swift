//
//  DetailCell.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/13/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class DetailCell: UICollectionViewCell {

    static let reuseId = "DetailCell"
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        addSubview(mainImageView)
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(15.0)
            make.bottom.equalToSuperview().offset(-15.0)
            make.left.equalToSuperview().offset(15.0)
            make.right.equalToSuperview().offset(-15.0)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func update(_ image: UIImage) {
        mainImageView.image = image
        setNeedsDisplay()
    }
}
