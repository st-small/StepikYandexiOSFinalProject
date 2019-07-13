//
//  DetailVC.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/13/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class DetailVC: UIViewController {
    
    // UI elements
    private var detailViewCollection = DetailViewCollectionView()
    
    // Data
    private var index: Int!
    private var images = [UIImage]()
    
    // Services
    private let notebook = FileNotebook.shared
    
    init(_ indexPath: IndexPath) {
        index = indexPath.row
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareCollectionView()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let indexPath = IndexPath(item: index, section: 0)
        detailViewCollection.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
    
    private func prepareCollectionView() {
        view.addSubview(detailViewCollection)
        detailViewCollection.translatesAutoresizingMaskIntoConstraints = false
        detailViewCollection.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        detailViewCollection.set(cells: prepareImages(notebook.notes))
    }
    
    private func prepareImages(_ notes: [Note]) -> [UIImage] {
        return notebook.notes.filter({ $0.image != nil }).map({ $0.image! })
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension DetailVC: FileNotebookDelegate {
    public func notesWereChanged() {
        detailViewCollection.reloadData()
    }
}
