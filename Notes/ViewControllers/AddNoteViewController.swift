//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Станислав Шияновский on 7/2/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public typealias ColorPoint = (color: UIColor?, brightness: Float?, point: CGPoint?)

public class AddNoteViewController: UIViewController {
    
    // UI elements
    @IBOutlet private weak var contentScroll: UIScrollView!
    @IBOutlet private weak var titleField: UITextField!
    @IBOutlet private weak var noteField: UITextView!
    @IBOutlet private weak var destroySwitch: UISwitch!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var colorsView: ColorsView!
    
    // Data
    private let noteViewPlaceholder = "Enter text for your note here..."
    private var colorPoint: ColorPoint?
    private var selectedColor: UIColor?
    private var note: Note
    
    // Services
    private let notificationCenter = NotificationCenter.default
    private let notebook = FileNotebook.shared
    
    init(_ noteUID: String? = nil) {
        note = notebook.notes.first(where: { $0.uid == noteUID }) ?? Note(title: "", content: "", importance: .normal)
        super.init(nibName: "AddNoteViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        note = Note(title: "", content: "", importance: .normal)
        super.init(coder: aDecoder)
    }
    
    public override func loadView() {
        super.loadView()
        
        configureScroll()
        configureTitleField()
        configureNoteField()
        configureDestroySwitch()
        configureDestroyDatePicker()
        configureColorsView()
    }
    
    private func configureScroll() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        contentScroll.addGestureRecognizer(tap)
    }
    
    private func configureTitleField() {
        titleField.text = note.title
    }
    
    private func configureNoteField() {
        noteField.delegate = self
        noteField.text = note.content.isEmpty ? noteViewPlaceholder : note.content
        noteField.textColor = UIColor.lightGray
    }
    
    private func configureDestroySwitch() {
        destroySwitch.addTarget(self, action: #selector(switcherValueChanged), for: .valueChanged)
        
        guard let _ = note.selfDestructionDate else { return }
        destroySwitch.setOn(true, animated: true)
    }
    
    private func configureDestroyDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.minimumDate = Date()
        updatePickerState()
        
        guard let date = note.selfDestructionDate else { return }
        datePicker.setDate(date, animated: true)
        updatePickerState(true)
    }
    
    private func configureColorsView() {
        guard note.color != .white else { return }
        colorsView.updateCustomColorView(note.color)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        colorsView.delegate = self
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let title = titleField.text ?? ""
        let color = selectedColor ?? note.color
        let destructionDate = destroySwitch.isOn ? datePicker.date : nil
        let newNote = Note(uid: note.uid, title: title, content: noteField.text, color: color, importance: note.importance, destructionDate: destructionDate)
        notebook.add(newNote)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentScroll.contentInset = .zero
        } else {
            contentScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func switcherValueChanged() {
        updatePickerState(destroySwitch.isOn)
    }
    
    private func updatePickerState(_ shouldShow: Bool = false) {
        let height: CGFloat = shouldShow ? 100.0 : 0.0
        datePicker.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}

extension AddNoteViewController: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if noteField.textColor == UIColor.lightGray {
            noteField.text = textView.text == noteViewPlaceholder ? "" : textView.text
            noteField.textColor = UIColor.black
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if noteField.text == "" {
            noteField.text = noteViewPlaceholder
            noteField.textColor = UIColor.lightGray
        }
    }
}

extension AddNoteViewController: ColorsViewDelegate {
    public func selectedColor(_ color: UIColor) {
        selectedColor = color
    }
    
    public func openColorPickerTapped() {
        hideKeyboard()
        let picker = ColorPickerViewController(colorPoint, delegate: self)
        self.navigationController?.pushViewController(picker, animated: true)
    }
}

extension AddNoteViewController: ColorPickerDelegate {
    public func didSelectColor(_ colorPoint: ColorPoint?) {
        guard let color = colorPoint?.color else { return }
        self.colorPoint = colorPoint
        selectedColor = color
        colorsView.updateCustomColorView(color)
    }
}
