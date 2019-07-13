//
//  GalleryVC.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/12/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class GalleryVC: UIViewController {

    // UI elements
    private var galleryCollection: GalleryCollectionView!
    
    // Data
    
    // Services
    private let imagePicker = UIImagePickerController()
    private let notebook = FileNotebook.shared
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareNavigationBar()
        prepareCollectionView()
    }
    
    private func prepareNavigationBar() {
        title = "Галерея"
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImageTapped))
        navigationItem.rightBarButtonItem = add
    }
    
    private func prepareCollectionView() {
        galleryCollection = GalleryCollectionView(self)
        view.addSubview(galleryCollection)
        galleryCollection.translatesAutoresizingMaskIntoConstraints = false
        galleryCollection.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        galleryCollection.set(cells: prepareNotes(notebook.notes))
    }
    
    private func prepareNotes(_ notes: [Note]) -> [Note] {
        return notebook.notes.filter({ $0.image != nil })
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        notebook.delegate = self
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @objc private func addImageTapped() {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension GalleryVC: UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let note = Note(title: "", content: "", importance: .normal, image: pickedImage)
            notebook.add(note)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension GalleryVC: UINavigationControllerDelegate { }
extension GalleryVC: FileNotebookDelegate {
    public func notesWereChanged() {
        galleryCollection.reloadData()
    }
}

extension GalleryVC: GalleryCollectionViewDelegate {
    public func didSelectItem(_ indexPath: IndexPath) {
        let detail = DetailVC(indexPath)
        navigationController?.pushViewController(detail, animated: true)
    }
}
