import Foundation
import SwiftyJSON

struct User {
    let id: Int64
    let handle: String
    let createdAt: NSDate
    var firstName: String?
    var lastName: String?
    
    init(data: JSON) {
        self.id = data["id"].int64Value // TODO: (wbjacks) right...?
        self.handle = data["handle"].stringValue
        self.createdAt = NSDate(timeIntervalSince1970: data["created_at"].doubleValue)
        self.firstName = data["first_name"].stringValue
        self.lastName = data["last_name"].stringValue
    }
}