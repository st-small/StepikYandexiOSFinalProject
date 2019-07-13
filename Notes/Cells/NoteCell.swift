//
//  NoteCell.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/12/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class NoteCell: UITableViewCell {

    public static let identifier = "NoteCell"
    private static let nibName = "NoteCell"
    
    // UI elements
    @IBOutlet private weak var importanceView: UIView!
    @IBOutlet private weak var noteTitle: UILabel!
    @IBOutlet private weak var noteText: UILabel!
    
    // Data
    private var note: Note!
    
    public static func register(in tableView: UITableView) {
        let nib = UINib.init(nibName: nibName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func update(_ note: Note) {
        self.note = note
        refresh()
    }
    
    private func refresh() {
        importanceView.backgroundColor = note.color
        noteTitle.text = note.title
        noteText.text = note.content
    }
}
