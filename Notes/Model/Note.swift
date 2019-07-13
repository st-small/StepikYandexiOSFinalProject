import UIKit

public enum NoteImportance: CaseIterable {
    case trivial
    case normal
    case important
    
    public static func initWith(rawValue: String?) -> NoteImportance {
        switch rawValue {
        case "trivial": return .trivial
        case "normal": return .normal
        case "important": return .important
        default: return .normal
        }
    }
    
    public var rawValue: String {
        switch self {
        case .trivial: return "trivial"
        case .normal: return "normal"
        case .important: return "important"
        }
    }
}

public struct Note {
    public let uid: String
    public let title: String
    public let content: String
    public let color: UIColor
    public let importance: NoteImportance
    public let selfDestructionDate: Date?
    public let image: UIImage?
    
    public init(uid: String = UUID().uuidString, title: String, content: String, color: UIColor = .white, importance: NoteImportance, destructionDate: Date? = nil, image: UIImage? = nil) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructionDate = destructionDate
        self.image = image
    }
}
