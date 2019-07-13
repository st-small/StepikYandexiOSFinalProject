//
//  DetailViewCollectionView.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/13/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class DetailViewCollectionView: UICollectionView {

    private var cells = [UIImage]()
    
    public init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .black
        delegate = self
        dataSource = self
        register(DetailCell.self, forCellWithReuseIdentifier: DetailCell.reuseId)
        
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = Constants.menuMinimumLineSpacing
        contentInset = UIEdgeInsets(top: Constants.topDistance, left: 16, bottom: Constants.bottomDistance, right: 16)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func set(cells: [UIImage]) {
        self.cells = cells
    }
}

extension DetailViewCollectionView: UICollectionViewDelegate { }
extension DetailViewCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = cells[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: DetailCell.reuseId, for: indexPath) as! DetailCell
        cell.update(item)
        return cell
    }
}

extension DetailViewCollectionView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.itemWidth, height: Constants.itemHeight)
    }
}

fileprivate struct Constants {
    static let topDistance: CGFloat = 15.0
    static let bottomDistance: CGFloat = 15.0
    static let menuMinimumLineSpacing: CGFloat = 10.0
    static let itemWidth: CGFloat = (UIScreen.main.bounds.width - 32.0)
    static let itemHeight: CGFloat = itemWidth
}
