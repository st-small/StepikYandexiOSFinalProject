//
//  GalleryCollectionView.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/13/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public protocol GalleryCollectionViewDelegate: class {
    func didSelectItem(_ indexPath: IndexPath)
}

public class GalleryCollectionView: UICollectionView {

    private var cells = [Note]()
    private weak var galleryDelegate: GalleryCollectionViewDelegate!
    
    public init(_ galleryDelegate: GalleryCollectionViewDelegate) {
        self.galleryDelegate = galleryDelegate
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        delegate = self
        dataSource = self
        register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.reuseId)
        
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = Constants.menuMinimumLineSpacing
        contentInset = UIEdgeInsets(top: Constants.topDistance, left: 16, bottom: Constants.bottomDistance, right: 16)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func set(cells: [Note]) {
        self.cells = cells
    }
}

extension GalleryCollectionView: UICollectionViewDelegate { }
extension GalleryCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = cells[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseId, for: indexPath) as! GalleryCell
        cell.update(item.image!)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        galleryDelegate.didSelectItem(indexPath)
    }
}

extension GalleryCollectionView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.itemWidth, height: Constants.itemHeight)
    }
}

fileprivate struct Constants {
    static let topDistance: CGFloat = 15.0
    static let bottomDistance: CGFloat = 15.0
    static let menuMinimumLineSpacing: CGFloat = 10.0
    static let itemWidth: CGFloat = (UIScreen.main.bounds.width - 32.0)/3 - 10.0
    static let itemHeight: CGFloat = itemWidth
}
