import UIKit

class Product {
    var name: String?
    var info: String?
    var loaded = false
    
    // If more columns are added or needed change the following value
    static let fields = [
        (title: "Serial", id: "Table Number"),
        (title: "Description", id: "Description"),
        (title: "Shipped Date", id: "Ship Date"),
        (title: "Customer", id: "Customer_Number")
    ]
    
    var info_dict = [String: String]()
    
    init(serial: String) {
        self.name = nil
        info_dict["Table Number"] = serial
    }
    
    init(name: String, serial: String) {
        self.name = name
        info_dict["Table Number"] = serial
    }
    
    init(dict: [String:String]) {
        for field in Product.fields {
            info_dict[field.id] = dict[field.id]
        }
    }
    
    func redefine(dict: [String:String]) -> Bool {
        for field in Product.fields {
            info_dict[field.id] = dict[field.id]
        }
        if info_dict[Product.fields[0].id] != nil {
            loaded = true
            return true
        } else { return false }
    }
    
    func set(id: String, val: String) {
        info_dict[id] = val
    }
    func setName(name: String) {
        let escaped_name = name.replacingOccurrences(of: AppDelegate.PRODUCT_SPLIT, with: "")
        self.name = escaped_name
    }
    func get(id: String) -> String {
        if let s = info_dict[id] {
            return s
        }
        return ""
    }
    func getTitle() -> String {
        if get(id: "Table Number") != "" {
            if getGivenName() != "" {
                return name! + " - " + get(id: "Table Number")
            }
            return get(id: "Table Number")
        }
        return getGivenName()
    }
    func getSubtitle() -> String {
        if loaded {
            if get(id: "Description") != "" {
                return niceify(s: get(id: "Description"))
            }
            return info ?? ""
        }
        return "Loading..."
    }
    func getSerial() -> String {
        return get(id: "Table Number")
    }
    func niceify(s: String) -> String {
        return s.capitalized
    }
    func toSaveString() -> String {
        return getGivenName() + AppDelegate.PRODUCT_SPLIT + get(id: "Table Number")
    }
    func getGivenName() -> String {
        return name ?? getSerial()
    }
    func toLabeledMultiline() -> String {
        var multi = ""
        for (index, field) in info_dict.enumerated() {
            multi += "\(field.key): \(field.value)"
            if index < info_dict.count - 1 {
                multi += "\n"
            }
        }
        return multi
    }
}
