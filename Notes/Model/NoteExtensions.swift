import UIKit

extension Note {
    public var json: [String: Any] {
        get {
            var valuesDictionary = [String: Any]()
            valuesDictionary["uid"] = uid
            valuesDictionary["title"] = title
            valuesDictionary["content"] = content
            valuesDictionary["color"] = color == .white ? nil : color.toHexString()
            valuesDictionary["importance"] = importance == .normal ? nil : importance.rawValue
            valuesDictionary["date"] = selfDestructionDate?.timeIntervalSince1970
            
            if let image = image {
                let imageData = image.jpegData(compressionQuality: 1)
                let base64String = imageData?.base64EncodedString()
                valuesDictionary["image"] = base64String
            }
            return valuesDictionary
        }
    }
    
    public static func parse(json: [String: Any]) -> Note? {
        guard
            let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String else { return nil }
        
        let color = json["color"] as? String ?? "#ffffff"
        let importanceValue = json["importance"] as? String
        let importance = NoteImportance.initWith(rawValue: importanceValue)
        
        var date: Date? = nil
        if let dateValue = json["date"] as? Double {
            date = Date(timeIntervalSince1970: dateValue)
        }
        
        var image: UIImage? = nil
        if let imageValue = json["image"] as? String {
            if let data = Data(base64Encoded: imageValue) {
                image = UIImage(data: data)
            }
        }
        
        return Note(uid: uid, title: title, content: content, color: UIColor.init(hexString: color), importance: importance, destructionDate: date, image: image)
    }
}

extension UIColor {
    public convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    public func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
