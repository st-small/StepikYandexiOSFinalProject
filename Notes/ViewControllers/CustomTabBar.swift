//
//  CustomTabBar.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/12/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class CustomTabBar: UITabBarController {
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notes = NotesVC()
        let notesIcon = UIImage(named: "tabbar-list")
        notes.tabBarItem = UITabBarItem(title: "Заметки", image: notesIcon, tag: 0)
        let notesNavigation = UINavigationController(rootViewController: notes)
        
        let gallery = GalleryVC()
        let galleryIcon = UIImage(named: "tabbar-gallery")
        gallery.tabBarItem = UITabBarItem(title: "Галерея", image: galleryIcon, tag: 1)
        let galleryNavigation = UINavigationController(rootViewController: gallery)
        
        viewControllers = [notesNavigation, galleryNavigation]
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}
