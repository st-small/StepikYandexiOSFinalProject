import UIKit

public protocol FileNotebookDelegate: class {
    func notesWereChanged()
}

public class FileNotebook {
    
    static public let shared = FileNotebook()
    public weak var delegate: FileNotebookDelegate?
    
    private (set) var notes: [Note]
    private let filename = "notes.txt"
    
    private init() {
        notes = []
        loadFromFile()
    }
    
    public func add(_ note: Note) {
        guard !notes.contains(where: { $0.uid == note.uid }) else {
            change(note)
            return
        }
        notes.append(note)
        saveToFile()
        delegate?.notesWereChanged()
    }
    
    private func change(_ note: Note) {
        guard let index = notes.lastIndex(where: { $0.uid == note.uid }) else { return }
        notes[index] = note
        saveToFile()
        delegate?.notesWereChanged()
    }
    
    public func remove(with uid: String) {
        guard let noteIndexToRemove = notes.firstIndex(where: { $0.uid == uid }) else { return }
        notes.remove(at: noteIndexToRemove)
        saveToFile()
        delegate?.notesWereChanged()
    }
    
    public func saveToFile() {
        let documentDirectory = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            let notesData = notes.map({ $0.json })
            let jsonData = try JSONSerialization.data(withJSONObject: notesData, options: [])
            try jsonData.write(to: documentDirectory)
        } catch { }
    }
    
    public func loadFromFile() {
        let documentDirectory = getDocumentsDirectory().appendingPathComponent(filename)
        
        if FileManager.default.fileExists(atPath: documentDirectory.path) {
            do {
                let data = try Data(contentsOf: documentDirectory)
                guard let notesArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
                notes = notesArray.compactMap{ Note.parse(json: $0) }
            } catch { }
        }
    }
    
    public func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
