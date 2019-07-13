//
//  NotesVC.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/12/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class NotesVC: UIViewController {
    
    // UI elements
    private var notesTable: UITableView!
    
    // Data
    private var notes = [Note]()
    private var tableViewIsEditing: Bool = false
    
    // Services
    private let notebook = FileNotebook.shared
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        prepareNavigationBar()
        prepareNotesTable()
        
        notebook.delegate = self
    }
    
    private func prepareNavigationBar() {
        title = "Заметки"
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        navigationItem.leftBarButtonItem = edit
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = add
    }
    
    private func prepareNotesTable() {
        notesTable = UITableView()
        view.addSubview(notesTable)
        notesTable.translatesAutoresizingMaskIntoConstraints = false
        notesTable.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        notesTable.dataSource = self
        notesTable.delegate = self
        NoteCell.register(in: notesTable)
        
        notesTable.tableFooterView = UIView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotes()
    }
    
    private func loadNotes() {
        if notebook.notes.isEmpty { prepareDemoNotes() }
        notes = filterNotes(notebook.notes)
        notesTable.reloadData()
    }
    
    private func filterNotes(_ notes: [Note]) -> [Note] {
        let onlyTextNotes = notes.filter({ $0.image == nil })
        let important = onlyTextNotes.filter({ $0.importance == .important })
        let normal = onlyTextNotes.filter({ $0.importance == .normal })
        let trivial = onlyTextNotes.filter({ $0.importance == .trivial })
        return important + normal + trivial
    }
    
    private func prepareDemoNotes() {
        (1...3).forEach { _ in
            let importance = NoteImportance.allCases.randomElement()
            let note = Note(title: randomString(length: 10), content: randomString(length: 1000), color: randomColor(), importance: importance!)
            notebook.add(note)
        }
    }
    
    private func randomString(length:Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = charSet.map { String($0) }
        var s:String = ""
        for _ in (1...length) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return insertRandomSpaces(s)
    }
    
    private func insertRandomSpaces(_ value: String) -> String {
        let random = Int.random(in: 3...7)
        var spacedString = ""
        for (index, item) in value.enumerated() {
            var newValue = String(item)
            if index % random == 0 {
                newValue += " "
            }
            spacedString.append(newValue)
        }
        return spacedString
    }
    
    private func randomColor() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @objc private func editButtonTapped() {
        tableViewIsEditing = !tableViewIsEditing
        notesTable.isEditing = tableViewIsEditing
    }
    
    @objc private func addButtonTapped() {
        openEditor()
    }
    
    private func openEditor(_ noteUID: String? = nil) {
        let editor = AddNoteViewController(noteUID)
        navigationController?.pushViewController(editor, animated: true)
    }
}

extension NotesVC: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        cell.update(note)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let noteUID = notes[indexPath.row].uid
        openEditor(noteUID)
    }
}

extension NotesVC: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let noteToRemove = notes[indexPath.row]
            notebook.remove(with: noteToRemove.uid)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension NotesVC: FileNotebookDelegate {
    public func notesWereChanged() {
        notes = filterNotes(notebook.notes)
        notesTable.reloadData()
    }
}
